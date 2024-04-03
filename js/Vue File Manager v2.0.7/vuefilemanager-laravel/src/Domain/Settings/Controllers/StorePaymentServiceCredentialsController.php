<?php
namespace Domain\Settings\Controllers;

use Artisan;
use Illuminate\Http\Response;
use Domain\Settings\Models\Setting;
use Domain\Settings\Requests\StorePaymentServiceCredentialsRequest;

class StorePaymentServiceCredentialsController
{
    /**
     * Configure stripe additionally
     */
    public function __invoke(StorePaymentServiceCredentialsRequest $request): Response
    {
        // Abort in demo mode
        abort_if(is_demo(), 204, 'Done.');

        $options = [
            'stripe'   => [
                'name'  => 'allowed_stripe',
                'value' => 1,
            ],
            'paypal'   => [
                'name'  => 'allowed_paypal',
                'value' => 1,
            ],
            'paystack' => [
                'name'  => 'allowed_paystack',
                'value' => 1,
            ],
        ];

        // Get options
        collect([$options[$request->input('service')]])
            ->each(fn ($setting) => Setting::updateOrCreate([
                'name' => $setting['name'],
            ], [
                'value' => $setting['value'],
            ]));

        // Get and store credentials
        if (! app()->runningUnitTests()) {
            $credentials = [
                'stripe'   => [
                    'STRIPE_PUBLIC_KEY'     => $request->input('key'),
                    'STRIPE_SECRET_KEY'     => $request->input('secret'),
                    'STRIPE_WEBHOOK_SECRET' => $request->input('webhook'),
                ],
                'paystack' => [
                    'PAYSTACK_PUBLIC_KEY' => $request->input('key'),
                    'PAYSTACK_SECRET'     => $request->input('secret'),
                ],
                'paypal'   => [
                    'PAYPAL_CLIENT_ID'     => $request->input('key'),
                    'PAYPAL_CLIENT_SECRET' => $request->input('secret'),
                    'PAYPAL_WEBHOOK_ID'    => $request->input('webhook'),
                    'PAYPAL_IS_LIVE'       => 'true',
                ],
            ];

            // Store credentials into the .env file
            setEnvironmentValue($credentials[$request->input('service')]);

            // TODO: call plan creation

            // Clear cache
            if (! is_dev()) {
                Artisan::call('cache:clear');
                Artisan::call('config:clear');
                Artisan::call('config:cache');
            }
        }

        return response('Done', 204);
    }
}
