# CollectAI

CollectAI is a B2B accounts-receivable workspace: track invoices, spot overdue money, and automate payment follow-ups.

## Run locally

```bash
npm install
cp .env.example .env
npm run dev
```

Without Supabase environment variables, the UI runs in demo mode with sample data. With the Lead Supabase project's URL and publishable/anon key, authentication and invoice/customer persistence are enabled.

## Supabase

Use only the publishable/anon key in the browser. Never place a service-role key in Vite env variables.
