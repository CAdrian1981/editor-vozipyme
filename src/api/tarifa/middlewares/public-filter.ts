import type { Context, Next } from "koa";

export default (_config: unknown, { strapi }: { strapi: any }) =>
  async (ctx: Context, next: Next) => {
    const model = strapi.getModel("api::tarifa.tarifa");
    const hasPermisos = !!model?.attributes?.permisos;

    const q = (ctx.query as any) || {};
    const currentFilters = (q.filters as Record<string, any> | undefined) ?? {};

    q.filters = hasPermisos
      ? { ...currentFilters, permisos: { $eq: "Todos" } }
      : currentFilters;

    ctx.query = q;
    await next();
  };
