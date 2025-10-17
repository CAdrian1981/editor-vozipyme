export default {
  routes: [
    {
      method: 'GET',
      path: '/tarifas-publicas',
      handler: 'api::tarifa.tarifa.find',
      config: { auth: false, middlewares: ['api::tarifa.public-filter'] },
    },
  ],
};
