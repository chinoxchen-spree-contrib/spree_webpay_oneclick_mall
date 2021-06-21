Spree::Core::Engine.routes.draw do
  # URL for start connection with WebpayWS
  scope '/oneclick_mall' do
    get  'pay', to: 'oneclick_mall_payment#pay', as:  :oneclick_mall_pay

    get  'subscription', to: 'oneclick_mall_subscription#subscription', as:  :oneclick_mall_subscription

    post 'subscribe', to: 'oneclick_mall_subscription#subscribe', as:  :oneclick_mall_subscribe

    post 'subscribe_confirmation', to: 'oneclick_mall_subscription#subscribe_confirmation', as:  :oneclick_mall_subscribe_confirmation

    get  'subscribe_success', to: 'oneclick_mall_subscription#subscribe_success', as:  :oneclick_mall_subscribe_success

    get  'subscribe_failure', to: 'oneclick_mall_subscription#subscribe_failure', as:  :oneclick_mall_subscribe_failure

    get  'unsubscription', to: 'oneclick_mall_subscription#unsubscription', as:  :oneclick_mall_unsubscription

    get 'unsubscribe', to: 'oneclick_mall_subscription#unsubscribe', as:  :oneclick_mall_unsubscribe

    get 'success', to: 'oneclick_mall_payment#success',  as:  :oneclick_mall_success

    get 'failure', to: 'oneclick_mall_payment#failure',  as:  :oneclick_mall_failure
  end
end
