

    -- drop view if exists order_agg_vw;

    create or replace view order_agg_vw as
    select d.order_id as id,
           d.order_id as order_id,
           sum(d.order_qty * d.unit_price) as order_total,
           sum(d.ship_qty * d.unit_price) as ship_total,
           sum(d.ship_qty * d.unit_price) as ship_total2
    from o_order_detail d
    group by d.order_id;

  