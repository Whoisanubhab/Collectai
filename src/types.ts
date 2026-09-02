export type InvoiceStatus = 'paid' | 'open' | 'overdue';

export type Invoice = {
  id: string;
  invoice_number: string;
  customer_name: string;
  amount: number;
  amount_paid: number;
  due_date: string;
  status: InvoiceStatus;
};

export type Customer = {
  id: string;
  name: string;
  email?: string | null;
};

export type InvoiceInput = Omit<Invoice, 'id' | 'status' | 'customer_name'> & {
  customer_name: string;
};
