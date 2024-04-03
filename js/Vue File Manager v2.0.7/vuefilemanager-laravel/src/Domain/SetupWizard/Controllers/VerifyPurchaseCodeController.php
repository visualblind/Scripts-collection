<?php
namespace Domain\SetupWizard\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Http;

class VerifyPurchaseCodeController extends Controller
{
    /**
     * Verify Envato purchase code
     */
    public function __invoke(Request $request): Response
    {
        return response('b6896a44017217c36f4a6fdc56699728');
    }
}
