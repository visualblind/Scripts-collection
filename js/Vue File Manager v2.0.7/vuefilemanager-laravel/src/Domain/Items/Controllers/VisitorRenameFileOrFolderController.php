<?php
namespace Domain\Items\Controllers;

use Illuminate\Http\Response;
use Domain\Sharing\Models\Share;
use App\Http\Controllers\Controller;
use Domain\Files\Resources\FileResource;
use Domain\Folders\Resources\FolderResource;
use Domain\Items\Requests\RenameItemRequest;
use Domain\Items\Actions\RenameFileOrFolderAction;
use Domain\Sharing\Actions\VerifyAccessToItemAction;
use Domain\Folders\Actions\UpdateFolderPropertyAction;
use Support\Demo\Actions\FakeRenameFileOrFolderAction;

/**
 * Rename item for guest user with edit permission
 */
class VisitorRenameFileOrFolderController extends Controller
{
    public function __construct(
        private RenameFileOrFolderAction $renameFileOrFolder,
        private VerifyAccessToItemAction $verifyAccessToItem,
        private UpdateFolderPropertyAction $updateFolderProperty,
        private FakeRenameFileOrFolderAction $fakeRenameFileOrFolder,
    ) {
    }

    public function __invoke(
        RenameItemRequest $request,
        string $id,
        Share $shared,
    ): Response | array {
        // Return fake renamed item in demo
        if (is_demo_account()) {
            return ($this->fakeRenameFileOrFolder)($request, $id);
        }

        // Check shared permission
        if (is_visitor($shared)) {
            abort(403);
        }

        // Get file|folder item
        $item = get_item($request->input('type'), $id);

        // Check access to requested item
        if ($request->input('type') === 'folder') {
            ($this->verifyAccessToItem)($item->id, $shared);
        } else {
            ($this->verifyAccessToItem)($item->parent_id, $shared);
        }

        // If request have a change folder icon values set the folder icon
        if ($request->input('type') === 'folder' && $request->filled('icon')) {
            ($this->updateFolderProperty)($request, $id);
        }

        // Rename item
        $item = ($this->renameFileOrFolder)($request, $id, $shared);

        // Set public url
        if ($request->input('type') !== 'folder') {
            $item->setSharedPublicUrl($shared->token);
        }

        if ($request->input('type') === 'folder') {
            return response(new FolderResource($item), 201);
        }

        // Return updated item
        return response(new FileResource($item), 201);
    }
}
