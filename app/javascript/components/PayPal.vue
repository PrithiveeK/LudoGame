<template>
  <div ref="paypal"></div>
</template>

<script>
const CLIENT_ID = process.env.PAYPAL_CLIENT_ID

export default {
  mounted() {
    const script = document.createElement("script");
    script.src = `https://www.paypal.com/sdk/js?client-id=${CLIENT_ID}&currency=INR`;
    script.onload = this.setLoaded;
    document.body.appendChild(script);
  },
  methods: {
    setLoaded: function() {
      window.paypal.Buttons({
        createOrder: (data, actions) => {
          return actions.order.create({
            purchase_units: [{
              description: 'You are purchasing this new piece',
              amount: {
                currency_code: "INR",
                value: 1
              }
            }]
          })
        },
        onApprove: async (data, actions) => {
          const order = await actions.order.capture();
          console.log(order);
        },
        onError: err => {
          console.log(err)
        }
      }).render(this.$refs.paypal)
    } 
  }
}
</script>