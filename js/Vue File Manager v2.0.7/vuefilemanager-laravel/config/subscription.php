<?php

return [
    /*
     * Get gateway credentials
     */
    'credentials'       => [
        'stripe'   => [
            'secret'      => env('STRIPE_SECRET_KEY'),
            'public_key'  => env('STRIPE_PUBLIC_KEY'),
            'webhook_key' => env('STRIPE_WEBHOOK_SECRET'),
        ],
        'paystack' => [
            'secret'     => env('PAYSTACK_SECRET'),
            'public_key' => env('PAYSTACK_PUBLIC_KEY'),
        ],
        'paypal'   => [
            'id'         => env('PAYPAL_CLIENT_ID'),
            'secret'     => env('PAYPAL_CLIENT_SECRET'),
            'webhook_id' => env('PAYPAL_WEBHOOK_ID'),
            'is_live'    => env('PAYPAL_IS_LIVE'),
        ],
    ],

    'notifications' => [
        'ChargeFromCreditCardFailedAgainNotification' => \Domain\Subscriptions\Notifications\ChargeFromCreditCardFailedAgainNotification::class,
        'ChargeFromCreditCardFailedNotification'      => \Domain\Subscriptions\Notifications\ChargeFromCreditCardFailedNotification::class,
        'SubscriptionWasCreatedNotification'          => \Domain\Subscriptions\Notifications\SubscriptionWasCreatedNotification::class,
        'BillingAlertTriggeredNotification'           => \Domain\Subscriptions\Notifications\BillingAlertTriggeredNotification::class,
        'ConfirmStripePaymentNotification'            => \Domain\Subscriptions\Notifications\ConfirmStripePaymentNotification::class,
        'InsufficientBalanceNotification'             => \Domain\Subscriptions\Notifications\InsufficientBalanceNotification::class,
        'BonusCreditAddedNotification'                => \Domain\Subscriptions\Notifications\BonusCreditAddedNotification::class,
    ],

    /*
     * Active drivers to handle subscription
     */
    'available_drivers' => [
        'paystack',
        'paypal',
        'stripe',
    ],

    'metered_billing'   => [
        'settlement_period' => 30,
    ],

    'paystack'          => [
        /*
         * List of allowed ip address to verify paystack webhook request
         */
        'allowed_ips' => [
            '52.214.14.220',
            '52.49.173.169',
            '52.31.139.75',
        ],
    ],

    'driver' => env('SUBSCRIPTION_DRIVER', 'stripe'),

    'is_demo' => env('APP_DEMO', false),
];
