export default ({ env }) => ({
  url: 'https://editor.vozipyme.es',
  proxy: true,
  host: '0.0.0.0',
  port: 1337,
  app: { keys: env.array('APP_KEYS', ['key1','key2']) },
  cors: {
    enabled: true,
    origin: [
      'https://editor.vozipyme.es',
      'http://localhost:1337',
      'http://localhost:3000',
    ],
  },
});
