-- CollectAI core schema
-- Run in Supabase SQL editor for a fresh project.

create extension if not exists pgcrypto;

create table if not exists public.collectai_businesses (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid not null references auth.users(id) on delete cascade,
  name text not null default 'My Business',
  created_at timestamptz not null default now()
);

create table if not exists public.collectai_customers (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null references public.collectai_businesses(id) on delete cascade,
  name text not null,
  email text,
  created_at timestamptz not null default now()
);

create table if not exists public.collectai_invoices (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null references public.collectai_businesses(id) on delete cascade,
  customer_id uuid references public.collectai_customers(id) on delete set null,
  invoice_number text not null,
  amount numeric(14,2) not null check (amount >= 0),
  amount_paid numeric(14,2) not null default 0 check (amount_paid >= 0 and amount_paid <= amount),
  due_date date not null,
  status text not null check (status in ('paid', 'open', 'overdue')),
  source text not null default 'manual',
  created_at timestamptz not null default now()
);

create index if not exists collectai_businesses_owner_idx on public.collectai_businesses(owner_user_id);
create index if not exists collectai_customers_business_idx on public.collectai_customers(business_id);
create index if not exists collectai_invoices_business_idx on public.collectai_invoices(business_id);
create index if not exists collectai_invoices_customer_idx on public.collectai_invoices(customer_id);
create index if not exists collectai_invoices_due_date_idx on public.collectai_invoices(business_id, due_date);

alter table public.collectai_businesses enable row level security;
alter table public.collectai_customers enable row level security;
alter table public.collectai_invoices enable row level security;

drop policy if exists "business owners can manage businesses" on public.collectai_businesses;
create policy "business owners can manage businesses"
on public.collectai_businesses
for all
using (owner_user_id = auth.uid())
with check (owner_user_id = auth.uid());

drop policy if exists "business owners can manage customers" on public.collectai_customers;
create policy "business owners can manage customers"
on public.collectai_customers
for all
using (exists (
  select 1 from public.collectai_businesses b
  where b.id = business_id and b.owner_user_id = auth.uid()
))
with check (exists (
  select 1 from public.collectai_businesses b
  where b.id = business_id and b.owner_user_id = auth.uid()
));

drop policy if exists "business owners can manage invoices" on public.collectai_invoices;
create policy "business owners can manage invoices"
on public.collectai_invoices
for all
using (exists (
  select 1 from public.collectai_businesses b
  where b.id = business_id and b.owner_user_id = auth.uid()
))
with check (exists (
  select 1 from public.collectai_businesses b
  where b.id = business_id and b.owner_user_id = auth.uid()
));
