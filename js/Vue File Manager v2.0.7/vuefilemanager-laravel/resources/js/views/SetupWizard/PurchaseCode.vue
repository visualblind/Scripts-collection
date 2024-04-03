<template>
    <AuthContentWrapper ref="auth" class="h-screen bg-white dark:bg-dark-background">
        <!--Licence Verify-->
        <AuthContent name="licence-verify" :visible="true">
            <Headline
                title="Setup Wizard"
                description="Please set your purchase code before continue to set up your application."
            >
                <settings-icon
                    size="40"
                    class="vue-feather text-theme mx-auto mb-3 animate-[spin_5s_linear_infinite]"
                />
            </Headline>

            <ValidationObserver
                @submit.prevent="verifyPurchaseCode"
                ref="verifyPurchaseCode"
                v-slot="{ invalid }"
                tag="form"
                class="mb-12 items-start space-y-4 md:flex md:space-x-4 md:space-y-0"
            >
                <ValidationProvider
                    tag="div"
                    mode="passive"
                    class="w-full text-left"
                    name="Purchase Code"
                    rules="required"
                    v-slot="{ errors }"
                >
                    <input
                        v-model="purchaseCode"
                        placeholder="Paste your purchase code"
                        type="text"
                        class="dark:placeholder:text-gray-600 focus-border-theme w-full appearance-none rounded-lg border border-transparent bg-light-background px-5 py-3.5 font-bold dark:bg-2x-dark-foreground"
                        :class="{ 'border-rose-600': errors[0] }"
                    />
                    <span class="text-left text-xs dark:text-rose-600 text-rose-600" v-if="errors[0]">{{ errors[0] }}</span>
                </ValidationProvider>
                <AuthButton
                    icon="chevron-right"
                    text="Verify"
                    class="w-full justify-center md:w-min"
                    :loading="isLoading"
                    :disabled="isLoading"
                />
            </ValidationObserver>

            <p class="block">
                <a
                    href="https://help.market.envato.com/hc/en-us/articles/202822600-Where-Is-My-Purchase-Code-"
                    target="_blank"
                    class="text-theme font-bold"
                    >Where I can find purchase code?
                </a>
                <a
                    class="black-link"
                    href="https://codecanyon.net/item/vue-file-manager-with-laravel-backend/25815986"
                    target="_blank"
                    >Don’t have purchase code?
                </a>
            </p>
        </AuthContent>
    </AuthContentWrapper>
</template>

<script>
import { ValidationProvider, ValidationObserver } from 'vee-validate/dist/vee-validate.full'
import AuthContentWrapper from '../../components/Auth/AuthContentWrapper'
import InfoBox from '../../components/Others/Forms/InfoBox'
import AuthContent from '../../components/Auth/AuthContent'
import AuthButton from '../../components/Auth/AuthButton'
import { SettingsIcon } from 'vue-feather-icons'
import { required } from 'vee-validate/dist/rules'
import Headline from '../Auth/Headline'
import axios from 'axios'

export default {
    name: 'PurchaseCode',
    components: {
        AuthContentWrapper,
        ValidationProvider,
        ValidationObserver,
        SettingsIcon,
        AuthContent,
        AuthButton,
        required,
        InfoBox,
        Headline,
    },
    data() {
        return {
            isLoading: false,
            isExtended: undefined,
            purchaseCode: '',
        }
    },
    methods: {
        lastCheckBeforeNextPage() {
            if 1>0 {
                this.$router.push({ name: 'Database' })
    },
}
}
</script>
