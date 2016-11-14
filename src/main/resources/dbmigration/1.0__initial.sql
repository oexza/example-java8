-- apply changes
create table o_address (
  id                            uuidPlaceholder not null,
  line1                         varchar(100),
  line2                         varchar(100),
  city                          varchar(100),
  country_code                  varchar(2),
  version                       bigint not null,
  when_created                  timestamptz not null,
  when_updated                  timestamptz not null,
  constraint pk_o_address primary key (id)
);

create table be_contact (
  id                            uuidPlaceholder not null,
  first_name                    varchar(50) not null,
  last_name                     varchar(50),
  email                         varchar(200),
  phone                         varchar(20),
  customer_id                   uuidPlaceholder not null,
  version                       bigint not null,
  when_created                  timestamptz not null,
  when_updated                  timestamptz not null,
  constraint pk_be_contact primary key (id)
);

create table o_country (
  code                          varchar(2) not null,
  name                          varchar(60),
  constraint pk_o_country primary key (code)
);

create table be_customer (
  id                            uuidPlaceholder not null,
  inactive                      boolean,
  name                          varchar(100),
  registered                    date,
  uids                          uuid[],
  comments                      varchar(255),
  billing_address_id            uuidPlaceholder,
  shipping_address_id           uuidPlaceholder,
  version                       bigint not null,
  when_created                  timestamptz not null,
  when_updated                  timestamptz not null,
  constraint pk_be_customer primary key (id)
);
comment on table be_customer is 'Customer table general comment';
comment on column be_customer.registered is 'The date the customer first registered';

create table o_order (
  id                            uuidPlaceholder not null,
  status                        varchar(1),
  order_date                    date,
  ship_date                     date,
  customer_id                   uuidPlaceholder not null,
  shipping_address_id           uuidPlaceholder,
  version                       bigint not null,
  when_created                  timestamptz not null,
  when_updated                  timestamptz not null,
  constraint ck_o_order_status check ( status in ('N','C','F','A','S')),
  constraint pk_o_order primary key (id)
);

create table o_order_detail (
  id                            uuidPlaceholder not null,
  order_id                      uuidPlaceholder,
  order_qty                     integer,
  ship_qty                      integer,
  unit_price                    float,
  product_id                    uuidPlaceholder,
  version                       bigint not null,
  when_created                  timestamptz not null,
  when_updated                  timestamptz not null,
  constraint pk_o_order_detail primary key (id)
);

create table o_order_shipment (
  id                            uuidPlaceholder not null,
  order_id                      uuidPlaceholder not null,
  shipped_on                    date,
  notes                         varchar(255),
  version                       bigint not null,
  when_created                  timestamptz not null,
  when_updated                  timestamptz not null,
  constraint pk_o_order_shipment primary key (id)
);

create table o_product (
  id                            uuidPlaceholder not null,
  sku                           varchar(20),
  name                          varchar(255),
  version                       bigint not null,
  when_created                  timestamptz not null,
  when_updated                  timestamptz not null,
  constraint pk_o_product primary key (id)
);

alter table o_address add constraint fk_o_address_country_code foreign key (country_code) references o_country (code) on delete restrict on update restrict;
create index ix_o_address_country_code on o_address (country_code);

alter table be_contact add constraint fk_be_contact_customer_id foreign key (customer_id) references be_customer (id) on delete restrict on update restrict;
create index ix_be_contact_customer_id on be_contact (customer_id);

alter table be_customer add constraint fk_be_customer_billing_address_id foreign key (billing_address_id) references o_address (id) on delete restrict on update restrict;
create index ix_be_customer_billing_address_id on be_customer (billing_address_id);

alter table be_customer add constraint fk_be_customer_shipping_address_id foreign key (shipping_address_id) references o_address (id) on delete restrict on update restrict;
create index ix_be_customer_shipping_address_id on be_customer (shipping_address_id);

alter table o_order add constraint fk_o_order_customer_id foreign key (customer_id) references be_customer (id) on delete restrict on update restrict;
create index ix_o_order_customer_id on o_order (customer_id);

alter table o_order add constraint fk_o_order_shipping_address_id foreign key (shipping_address_id) references o_address (id) on delete restrict on update restrict;
create index ix_o_order_shipping_address_id on o_order (shipping_address_id);

alter table o_order_detail add constraint fk_o_order_detail_order_id foreign key (order_id) references o_order (id) on delete restrict on update restrict;
create index ix_o_order_detail_order_id on o_order_detail (order_id);

alter table o_order_detail add constraint fk_o_order_detail_product_id foreign key (product_id) references o_product (id) on delete restrict on update restrict;
create index ix_o_order_detail_product_id on o_order_detail (product_id);

alter table o_order_shipment add constraint fk_o_order_shipment_order_id foreign key (order_id) references o_order (id) on delete restrict on update restrict;
create index ix_o_order_shipment_order_id on o_order_shipment (order_id);

