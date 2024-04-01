require 'stripe'
Stripe.api_key =  "sk_test_51OxwgiGiSYlcdrXuggG8dgSpralpK54txxnRDXeGB3KZh7ChXWs6ldlxJmsGseG0EfYA52sh0DRrtnVLJSjgR8Xi00HNfhQv3N"
Rails.logger.debug "Stripe API Key: #{Stripe.api_key}"
