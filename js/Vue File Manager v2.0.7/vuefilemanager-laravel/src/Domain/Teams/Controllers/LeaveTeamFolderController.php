<?php
namespace Domain\Teams\Controllers;

use Auth;
use Gate;
use Illuminate\Http\Response;
use Domain\Folders\Models\Folder;
use App\Http\Controllers\Controller;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Contracts\Routing\ResponseFactory;
use Domain\Teams\Actions\TransferContentOwnershipToTeamFolderOwnerAction;

class LeaveTeamFolderController extends Controller
{
    public function __construct(
        public TransferContentOwnershipToTeamFolderOwnerAction $transferContentOwnership,
    ) {
    }

    public function __invoke(Folder $folder): Response|Application|ResponseFactory
    {
        // Abort in demo mode
        if (is_demo_account()) {
            return response('Done.', 204);
        }

        // Authorize action
        if (! Gate::any(['can-edit', 'can-view'], [$folder, null])) {
            abort(403, 'Access Denied');
        }

        // Transfer files/folders ownership to team folder owner
        ($this->transferContentOwnership)($folder, Auth::id());

        return response('Done.', 204);
    }
}
