<?php
namespace Tests\Domain\Teams;

use Str;
use Notification;
use Tests\TestCase;
use App\Users\Models\User;
use Domain\Files\Models\File;
use Domain\Folders\Models\Folder;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Domain\Teams\Models\TeamFolderInvitation;
use Domain\Teams\Notifications\InvitationIntoTeamFolder;

class TeamManagementTest extends TestCase
{
    /**
     * @test
     */
    public function it_get_team_folder_invite()
    {
        [$inviter, $member] = User::factory()
            ->hasSettings()
            ->count(2)
            ->create();

        $invitation = TeamFolderInvitation::factory()
            ->create([
                'inviter_id' => $inviter->id,
                'parent_id'  => Str::uuid(),
                'email'      => $member->email,
                'status'     => 'pending',
                'permission' => 'can-edit',
            ]);

        $this->getJson("/api/teams/invitations/{$invitation->id}")
            ->assertOk()
            ->assertJsonFragment([
                'name' => $inviter->settings->name,
            ]);
    }

    /**
     * @test
     */
    public function it_accept_team_folder_invite_as_registered_user()
    {
        $member = User::factory()
            ->create([
                'email' => 'john@internal.com',
            ]);

        $folder = Folder::factory()
            ->create();

        $invitation = TeamFolderInvitation::factory()
            ->create([
                'parent_id'  => $folder->id,
                'email'      => $member->email,
                'status'     => 'pending',
                'permission' => 'can-view',
            ]);

        DB::table('notifications')
            ->insert([
                'id'              => Str::uuid(),
                'type'            => 'Domain\UploadRequest\Notifications\UploadRequestFulfilledNotification',
                'notifiable_type' => 'App\Users\Models\User',
                'notifiable_id'   => $member->id,
                'data'            => json_encode([
                    'type'        => 'team-invitation',
                    'title'       => 'New Team Invitation',
                    'description' => 'Jane Doe invite you to join into Team Folder..',
                    'action'      => [
                        'type'   => 'invitation',
                        'params' => [
                            'type'   => 'invitation',
                            'params' => [
                                'id' => $invitation->id,
                            ],
                        ],
                    ],
                ]),
                'created_at'      => now(),
                'updated_at'      => now(),
            ]);

        $this
            ->actingAs($member)
            ->putJson("/api/teams/invitations/{$invitation->id}")
            ->assertNoContent();

        // Get notification
        $notification = json_decode(DB::table('notifications')->first()->data);

        // Check if action is null
        $this->assertEquals(null, $notification->action);

        $this
            ->assertDatabaseHas('team_folder_invitations', [
                'parent_id' => $folder->id,
                'status'    => 'accepted',
            ])
            ->assertDatabaseHas('team_folder_members', [
                'parent_id'  => $folder->id,
                'user_id'    => $member->id,
                'permission' => 'can-view',
            ]);
    }

    /**
     * @test
     */
    public function it_accept_team_folder_invite_as_guest_user()
    {
        $folder = Folder::factory()
            ->create();

        $invitation = TeamFolderInvitation::factory()
            ->create([
                'parent_id'  => $folder->id,
                'email'      => 'howdy@hi5ve.digital',
                'status'     => 'pending',
                'permission' => 'can-edit',
            ]);

        $this
            ->putJson("/api/teams/invitations/{$invitation->id}")
            ->assertNoContent();

        $this
            ->assertDatabaseHas('team_folder_invitations', [
                'parent_id' => $folder->id,
                'status'    => 'waiting-for-registration',
            ])
            ->assertDatabaseMissing('team_folder_members', [
                'parent_id'  => $folder->id,
                'permission' => 'can-edit',
            ]);
    }

    /**
     * @test
     */
    public function it_apply_accepted_invitation_after_user_registration()
    {
        $invitation = TeamFolderInvitation::factory()
            ->create([
                'email'      => 'john@doe.com',
                'status'     => 'waiting-for-registration',
            ]);

        $this->postJson('api/register', [
            'email'                 => 'john@doe.com',
            'password'              => 'SecretPassword',
            'password_confirmation' => 'SecretPassword',
            'name'                  => 'John Doe',
        ])->assertStatus(201);

        $this
            ->assertDatabaseHas('team_folder_invitations', [
                'parent_id' => $invitation->parent_id,
                'status'    => 'accepted',
            ])
            ->assertDatabaseHas('team_folder_members', [
                'parent_id'  => $invitation->parent_id,
                'user_id'    => User::first()->id,
                'permission' => $invitation->permission,
            ]);
    }

    /**
     * @test
     */
    public function it_get_used_team_folder_invite()
    {
        $invitation = TeamFolderInvitation::factory()
            ->create(['status' => 'accepted']);

        $this
            ->getJson("/api/teams/invitations/{$invitation->id}")
            ->assertStatus(410);
    }

    /**
     * @test
     */
    public function it_reject_team_folder_invite()
    {
        $member = User::factory()
            ->create([
                'email' => 'john@internal.com',
            ]);

        $folder = Folder::factory()
            ->create();

        $invitation = TeamFolderInvitation::factory()
            ->create([
                'parent_id'  => $folder->id,
                'email'      => $member->email,
                'status'     => 'pending',
                'permission' => 'can-edit',
            ]);

        DB::table('notifications')
            ->insert([
                'id'              => Str::uuid(),
                'type'            => 'Domain\UploadRequest\Notifications\UploadRequestFulfilledNotification',
                'notifiable_type' => 'App\Users\Models\User',
                'notifiable_id'   => $member->id,
                'data'            => json_encode([
                    'type'        => 'team-invitation',
                    'title'       => 'New Team Invitation',
                    'description' => 'Jane Doe invite you to join into Team Folder..',
                    'action'      => [
                        'type'   => 'invitation',
                        'params' => [
                            'type'   => 'invitation',
                            'params' => [
                                'id' => $invitation->id,
                            ],
                        ],
                    ],
                ]),
                'created_at'      => now(),
                'updated_at'      => now(),
            ]);

        $this
            ->actingAs($member)
            ->deleteJson("/api/teams/invitations/{$invitation->id}")
            ->assertNoContent();

        // Get notification
        $notification = json_decode(DB::table('notifications')->first()->data);

        // Check if action is null
        $this->assertEquals(null, $notification->action);

        $this
            ->assertDatabaseHas('team_folder_invitations', [
                'parent_id' => $folder->id,
                'status'    => 'rejected',
            ])
            ->assertDatabaseMissing('team_folder_members', [
                'parent_id' => $folder->id,
                'user_id'   => $member->id,
            ]);
    }

    /**
     * @test
     */
    public function it_invite_member_into_team_folder()
    {
        [$user, $member_1, $member_2] = User::factory()
            ->hasSettings()
            ->count(3)
            ->create();

        $folder = Folder::factory()
            ->create([
                'user_id'     => $user->id,
                'team_folder' => 1,
            ]);

        TeamFolderInvitation::factory()
            ->create([
                'parent_id'  => $folder->id,
                'status'     => 'pending',
                'permission' => 'can-edit',
                'email'      => 'existing@member.com',
            ]);

        DB::table('team_folder_members')
            ->insert([
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_1->id,
                    'permission' => 'can-edit',
                ],
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_2->id,
                    'permission' => 'can-edit',
                ],
            ]);

        $this
            ->actingAs($user)
            ->patchJson("/api/teams/folders/{$folder->id}", [
                'members'     => [
                    [
                        'id'         => $member_1->id,
                        'permission' => 'can-edit',
                    ],
                    [
                        'id'         => $member_2->id,
                        'permission' => 'can-edit',
                    ],
                ],
                'invitations' => [
                    [
                        'id'         => null,
                        'email'      => 'existing@member.com',
                        'permission' => 'can-edit',
                    ],
                    [
                        'id'         => null,
                        'email'      => 'added@member.com',
                        'permission' => 'can-view',
                    ],
                ],
            ])
            ->assertCreated();

        $this
            ->assertDatabaseCount('team_folder_members', 2)
            ->assertDatabaseCount('team_folder_invitations', 2)
            ->assertDatabaseHas('team_folder_invitations', [
                'email'      => 'added@member.com',
                'permission' => 'can-view',
            ]);

        Notification::assertTimesSent(1, InvitationIntoTeamFolder::class);
    }

    /**
     * @test
     */
    public function it_delete_invited_member_from_team_folder()
    {
        [$user, $member_1, $member_2] = User::factory()
            ->hasSettings()
            ->count(3)
            ->create();

        $folder = Folder::factory()
            ->create([
                'user_id'     => $user->id,
                'team_folder' => 1,
            ]);

        TeamFolderInvitation::factory()
            ->create([
                'parent_id'  => $folder->id,
                'status'     => 'pending',
                'permission' => 'can-edit',
                'email'      => 'deleted@member.com',
            ]);

        TeamFolderInvitation::factory()
            ->create([
                'parent_id'  => $folder->id,
                'status'     => 'pending',
                'permission' => 'can-edit',
                'email'      => 'existing@member.com',
            ]);

        DB::table('team_folder_members')
            ->insert([
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_1->id,
                    'permission' => 'can-edit',
                ],
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_2->id,
                    'permission' => 'can-edit',
                ],
            ]);

        $this
            ->actingAs($user)
            ->patchJson("/api/teams/folders/{$folder->id}", [
                'members'     => [
                    [
                        'id'         => $member_1->id,
                        'permission' => 'can-edit',
                    ],
                    [
                        'id'         => $member_2->id,
                        'permission' => 'can-view',
                    ],
                ],
                'invitations' => [
                    [
                        'id'         => null,
                        'email'      => 'existing@member.com',
                        'permission' => 'can-view',
                    ],
                ],
            ])
            ->assertCreated();

        $this
            ->assertDatabaseCount('team_folder_members', 2)
            ->assertDatabaseCount('team_folder_invitations', 1)
            ->assertDatabaseHas('team_folder_invitations', [
                'email' => 'existing@member.com',
            ]);
    }

    /**
     * @test
     */
    public function it_remove_member_from_team_folder()
    {
        [$user, $member, $deletedMember] = User::factory()
            ->hasSettings()
            ->count(3)
            ->create();

        $folder = Folder::factory()
            ->create([
                'user_id'     => $user->id,
                'team_folder' => 1,
            ]);

        // Create fake file record
        File::factory()
            ->create([
                'name'      => 'Member File',
                'basename'  => 'fake-file.zip',
                'parent_id' => $folder->id,
                'user_id'   => $deletedMember->id,
                'type'      => 'file',
            ]);

        // Create fake file
        $fakeFile = UploadedFile::fake()
            ->create('fake-file.zip', 2000, 'application/zip');

        // Put fake file into correct directory
        Storage::putFileAs("files/{$deletedMember->id}", $fakeFile, 'fake-file.zip');

        // Attach members to the team folder
        DB::table('team_folder_members')
            ->insert([
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member->id,
                    'permission' => 'can-edit',
                ],
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $deletedMember->id,
                    'permission' => 'can-edit',
                ],
            ]);

        // Update team folder members
        $this
            ->actingAs($user)
            ->patchJson("/api/teams/folders/{$folder->id}", [
                'members'     => [
                    [
                        'id'         => $member->id,
                        'permission' => 'can-edit',
                    ],
                ],
                'invitations' => [],
            ])
            ->assertCreated();

        // Check if file was moved from member directory to owner directory
        Storage::assertMissing("files/{$deletedMember->id}/fake-file.zip");
        Storage::assertExists("files/{$user->id}/fake-file.zip");

        $this
            ->assertDatabaseCount('team_folder_members', 1)
            ->assertDatabaseMissing('team_folder_members', [
                'user_id' => $deletedMember->id,
            ]);
    }

    /**
     * @test
     */
    public function it_update_invited_member_permission_in_team_folder()
    {
        $user = User::factory()
            ->hasSettings()
            ->create();

        $folder = Folder::factory()
            ->create([
                'user_id'     => $user->id,
                'team_folder' => 1,
            ]);

        TeamFolderInvitation::factory()
            ->create([
                'parent_id'  => $folder->id,
                'status'     => 'pending',
                'permission' => 'can-view',
                'email'      => 'existing@member.com',
            ]);

        $this
            ->actingAs($user)
            ->patchJson("/api/teams/folders/{$folder->id}", [
                'members'     => [],
                'invitations' => [
                    [
                        'id'         => null,
                        'email'      => 'existing@member.com',
                        'permission' => 'can-edit',
                    ],
                ],
            ])
            ->assertCreated();

        $this
            ->assertDatabaseCount('team_folder_members', 0)
            ->assertDatabaseCount('team_folder_invitations', 1)
            ->assertDatabaseHas('team_folder_invitations', [
                'email'      => 'existing@member.com',
                'permission' => 'can-edit',
            ]);

        Notification::assertTimesSent(0, InvitationIntoTeamFolder::class);
    }

    /**
     * @test
     */
    public function it_update_member_permission_in_team_folder()
    {
        [$user, $member_1, $member_2] = User::factory()
            ->hasSettings()
            ->count(3)
            ->create();

        $folder = Folder::factory()
            ->create([
                'user_id'     => $user->id,
                'team_folder' => 1,
            ]);

        DB::table('team_folder_members')
            ->insert([
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_1->id,
                    'permission' => 'can-edit',
                ],
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_2->id,
                    'permission' => 'can-edit',
                ],
            ]);

        $this
            ->actingAs($user)
            ->patchJson("/api/teams/folders/{$folder->id}", [
                'members'     => [
                    [
                        'id'         => $member_1->id,
                        'permission' => 'can-edit',
                    ],
                    [
                        'id'         => $member_2->id,
                        'permission' => 'can-view',
                    ],
                ],
                'invitations' => [],
            ])
            ->assertCreated();

        $this->assertDatabaseHas('team_folder_members', [
            'user_id'    => $member_2->id,
            'permission' => 'can-view',
        ]);
    }

    /**
     * @test
     */
    public function member_try_update_permission_in_team_folder()
    {
        [$user, $member_1, $member_2] = User::factory()
            ->count(3)
            ->create();

        $folder = Folder::factory()
            ->create([
                'user_id'     => $user->id,
                'team_folder' => 1,
            ]);

        DB::table('team_folder_members')
            ->insert([
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_1->id,
                    'permission' => 'can-edit',
                ],
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_2->id,
                    'permission' => 'can-edit',
                ],
            ]);

        $this
            ->actingAs(
                User::find($member_1->id)
            )
            ->patchJson("/api/teams/folders/{$folder->id}", [
                'members'     => [
                    [
                        'id'         => $member_1->id,
                        'permission' => 'can-edit',
                    ],
                    [
                        'id'         => $member_2->id,
                        'permission' => 'can-view',
                    ],
                ],
                'invitations' => [],
            ])
            ->assertForbidden();

        $this->assertDatabaseHas('team_folder_members', [
            'user_id'    => $member_2->id,
            'permission' => 'can-edit',
        ]);
    }

    /**
     * @test
     */
    public function it_dissolve_team_folder()
    {
        [$user, $member_1, $member_2] = User::factory()
            ->count(3)
            ->create();

        $folder = Folder::factory()
            ->create([
                'user_id'     => $user->id,
                'team_folder' => 1,
            ]);

        $folderWithin = Folder::factory()
            ->create([
                'parent_id'   => $folder->id,
                'user_id'     => $user->id,
                'team_folder' => 1,
            ]);

        TeamFolderInvitation::factory()
            ->create([
                'parent_id'  => $folder->id,
                'status'     => 'pending',
                'permission' => 'can-edit',
            ]);

        DB::table('team_folder_members')
            ->insert([
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_1->id,
                    'permission' => 'can-edit',
                ],
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_2->id,
                    'permission' => 'can-edit',
                ],
            ]);

        $this
            ->actingAs($user)
            ->deleteJson("/api/teams/folders/{$folder->id}")
            ->assertNoContent();

        $this
            ->assertDatabaseCount('team_folder_members', 0)
            ->assertDatabaseCount('team_folder_invitations', 0)
            ->assertDatabaseHas('folders', [
                'id'          => $folder->id,
                'team_folder' => 0,
            ])
            ->assertDatabaseHas('folders', [
                'id'          => $folderWithin->id,
                'team_folder' => 0,
            ]);
    }

    /**
     * @test
     */
    public function it_leave_team_folder()
    {
        [$user, $member] = User::factory()
            ->count(2)
            ->create();

        $folder = Folder::factory()
            ->create([
                'name'        => 'Team Folder',
                'user_id'     => $user->id,
                'team_folder' => 1,
            ]);

        $folderWithin = Folder::factory()
            ->create([
                'name'        => 'Member Content',
                'parent_id'   => $folder->id,
                'user_id'     => $member->id,
                'team_folder' => 1,
            ]);

        $file = File::factory()
            ->create([
                'name'      => 'Member File',
                'basename'  => 'fake-file.zip',
                'parent_id' => $folderWithin->id,
                'user_id'   => $member->id,
                'type'      => 'file',
            ]);

        // Create fake file
        $fakeFile = UploadedFile::fake()
            ->create('fake-file.zip', 2000, 'application/zip');

        // Put fake file into correct directory
        Storage::putFileAs("files/$member->id", $fakeFile, 'fake-file.zip');

        File::factory()
            ->create([
                'name'      => 'Good image',
                'basename'  => 'fake-image.jpeg',
                'parent_id' => $folderWithin->id,
                'user_id'   => $member->id,
                'type'      => 'image',
            ]);

        // Create fake image
        $fakeFile = UploadedFile::fake()
            ->create('fake-image.jpeg', 2000, 'image/jpeg');

        // Put fake image into correct directory
        Storage::putFileAs("files/$member->id", $fakeFile, $fakeFile->name);

        $thumbnail_sizes = collect([config('vuefilemanager.image_sizes.later'), config('vuefilemanager.image_sizes.immediately')])->collapse();

        // Create fake image thumbnails
        $thumbnail_sizes
            ->each(function ($item) use ($member) {
                $fakeFile = UploadedFile::fake()
                    ->create("{$item['name']}-fake-image.jpeg", 2000, 'image/jpeg');

                Storage::putFileAs("files/$member->id", $fakeFile, $fakeFile->name);
            });

        // add member to the team folder
        DB::table('team_folder_members')
            ->insert([
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member->id,
                    'permission' => 'can-edit',
                ],
            ]);

        $this
            ->actingAs($member)
            ->deleteJson("/api/teams/folders/{$folder->id}/leave")
            ->assertNoContent();

        // Check if file was moved from member directory to owner directory
        Storage::assertMissing("files/$member->id/fake-file.zip");
        Storage::assertExists("files/$user->id/fake-file.zip");

        // Assert if image thumbnails was moved correctly to the new destination
        $thumbnail_sizes
            ->each(function ($item) use ($user) {
                Storage::assertExists("files/$user->id/{$item['name']}-fake-image.jpeg");
            });

        $this
            ->assertDatabaseMissing('team_folder_members', [
                'parent_id'  => $folder->id,
                'user_id'    => $member->id,
                'permission' => 'can-edit',
            ])
            ->assertDatabaseHas('files', [
                'id'        => $file->id,
                'parent_id' => $folderWithin->id,
                'user_id'   => $user->id,
            ])
            ->assertDatabaseHas('folders', [
                'id'        => $folderWithin->id,
                'parent_id' => $folder->id,
                'user_id'   => $user->id,
            ]);
    }

    /**
     * @test
     */
    public function member_try_dissolve_team_folder()
    {
        [$user, $member_1, $member_2] = User::factory()
            ->count(3)
            ->create();

        $folder = Folder::factory()
            ->create([
                'user_id'     => $user->id,
                'team_folder' => 1,
            ]);

        TeamFolderInvitation::factory()
            ->create([
                'parent_id'  => $folder->id,
                'status'     => 'pending',
                'permission' => 'can-edit',
            ]);

        DB::table('team_folder_members')
            ->insert([
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_1->id,
                    'permission' => 'can-edit',
                ],
                [
                    'parent_id'  => $folder->id,
                    'user_id'    => $member_2->id,
                    'permission' => 'can-edit',
                ],
            ]);

        $this
            ->actingAs(
                User::find($member_1->id)
            )
            ->deleteJson("/api/teams/folders/{$folder->id}")
            ->assertForbidden();

        $this
            ->assertDatabaseCount('team_folder_members', 2)
            ->assertDatabaseCount('team_folder_invitations', 1);
    }
}
