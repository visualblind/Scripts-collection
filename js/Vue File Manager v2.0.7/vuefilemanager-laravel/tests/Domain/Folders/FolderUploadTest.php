<?php
namespace Tests\Domain\Folders;

use Tests\TestCase;
use App\Users\Models\User;
use Domain\Files\Models\File;
use Domain\Folders\Models\Folder;
use Illuminate\Http\UploadedFile;

class FolderUploadTest extends TestCase
{
    /**
     * @test
     */
    public function upload_single_file_to_the_folder()
    {
        $user = User::factory()
            ->hasSettings()
            ->create();

        $file = UploadedFile::fake()
            ->create('fake-file.pdf', 120000, 'application/pdf');

        $folder = Folder::factory()
            ->create([
                'user_id'   => $user->id,
                'parent_id' => null,
            ]);

        $this
            ->actingAs($user)
            ->postJson('/api/upload', [
                'filename'  => $file->name,
                'file'      => $file,
                'path'      => '/',
                'parent_id' => $folder->id,
                'is_last'   => 'true',
            ])->assertStatus(201);

        $file = File::first();

        $this->assertEquals($file->parent_id, $folder->id);

        $this->assertDatabaseCount('folders', 1);
    }

    /**
     * @test
     */
    public function check_folder_tree_structure_creation_after_folder_upload()
    {
        $user = User::factory()
            ->hasSettings()
            ->create();

        $file = UploadedFile::fake()
            ->create('fake-file_1.pdf', 120000, 'application/pdf');

        $this
            ->actingAs($user)
            ->postJson('/api/upload', [
                'filename'  => $file->name,
                'file'      => $file,
                'path'      => "/level_1/level_2/level_3/$file->name",
                'parent_id' => null,
                'is_last'   => 'true',
            ])->assertStatus(201);

        $this
            ->actingAs($user)
            ->postJson('/api/upload', [
                'filename'  => $file->name,
                'file'      => $file,
                'path'      => "/level_1/level_2/level_3/$file->name",
                'parent_id' => null,
                'is_last'   => 'true',
            ])->assertStatus(201);

        $file = File::first();

        $level_1 = Folder::where('name', 'level_1')->first();
        $level_2 = Folder::where('name', 'level_2')->first();
        $level_3 = Folder::where('name', 'level_3')->first();

        $this->assertEquals(null, $level_1->parent_id);
        $this->assertEquals($level_2->parent_id, $level_1->id);
        $this->assertEquals($level_3->parent_id, $level_2->id);

        $this->assertEquals($level_3->id, $file->parent_id);

        $this->assertDatabaseCount('folders', 3);
    }

    /**
     * @test
     */
    public function duplicity_paths_test()
    {
        $user = User::factory()
            ->hasSettings()
            ->create();

        $level_1 = Folder::factory()
            ->create([
                'name'      => 'level_1',
                'user_id'   => $user->id,
                'parent_id' => null,
            ]);

        $level_2 = Folder::factory()
            ->create([
                'name'      => 'level_2',
                'user_id'   => $user->id,
                'parent_id' => $level_1->id,
            ]);

        Folder::factory()
            ->create([
                'name'      => 'level_3',
                'user_id'   => $user->id,
                'parent_id' => $level_2->parent_id,
            ]);

        $file = UploadedFile::fake()
            ->create('fake-file.pdf', 120000, 'application/pdf');

        $this
            ->actingAs($user)
            ->postJson('/api/upload', [
                'filename'  => $file->name,
                'file'      => $file,
                'path'      => "/another_folder/level_2/level_3/$file->name",
                'parent_id' => null,
                'is_last'   => 'true',
            ])->assertStatus(201);

        // Root folders
        $this->assertEquals(1, Folder::where('name', 'another_folder')->count());
        $this->assertEquals(1, Folder::where('name', 'level_1')->count());

        // Unique children folders
        $this->assertEquals(2, Folder::where('name', 'level_2')->count());
        $this->assertEquals(2, Folder::where('name', 'level_3')->count());

        $this->assertDatabaseCount('folders', 6);
    }

    /**
     * @test
     */
    public function check_children_tree_structure_creation_after_folder_upload()
    {
        $user = User::factory()
            ->hasSettings()
            ->create();

        $brother = UploadedFile::fake()
            ->create('brother.pdf', 120000, 'application/pdf');

        $sister = UploadedFile::fake()
            ->create('sister.pdf', 120000, 'application/pdf');

        $this
            ->actingAs($user)
            ->postJson('/api/upload', [
                'filename'  => $brother->name,
                'file'      => $brother,
                'path'      => "/Folder/Brother/$brother->name",
                'parent_id' => null,
                'is_last'   => 'true',
            ])->assertStatus(201);

        $this
            ->actingAs($user)
            ->postJson('/api/upload', [
                'filename'  => $sister->name,
                'file'      => $sister,
                'path'      => "/Folder/Sister/$sister->name",
                'parent_id' => null,
                'is_last'   => 'true',
            ])->assertStatus(201);

        $brotherFile = File::where('name', 'brother.pdf')->first();
        $sisterFile = File::where('name', 'sister.pdf')->first();

        $brotherFolder = Folder::where('name', 'Brother')->first();
        $sisterFolder = Folder::where('name', 'Sister')->first();

        // Check correctness of siblings file appended to the folder
        $this->assertEquals($brotherFolder->id, $brotherFile->parent_id);
        $this->assertEquals($sisterFolder->id, $sisterFile->parent_id);

        $home = Folder::where('name', 'Folder')->first();

        // Check correctness of siblings folders appended to the home folder
        $this->assertEquals($home->id, $brotherFolder->parent_id);
        $this->assertEquals($home->id, $sisterFolder->parent_id);

        $this->assertEquals(null, $home->parent_id);

        $this->assertDatabaseCount('folders', 3);
    }
}
