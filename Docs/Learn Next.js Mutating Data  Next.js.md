In the previous chapter, you implemented search and pagination using URL Search Params and Next.js APIs. Let's continue working on the Invoices page by adding the ability to create, update, and delete invoices!

In this chapter...

Here are the topics we’ll cover

What React Server Actions are and how to use them to mutate data.

How to work with forms and Server Components.

Best practices for working with the native `formData` object, including type validation.

How to revalidate the client cache using the `revalidatePath` API.

How to create dynamic route segments with specific IDs.

## [What are Server Actions?](https://nextjs.org/learn/dashboard-app/mutating-data#what-are-server-actions)

React Server Actions allow you to run asynchronous code directly on the server. They eliminate the need to create API endpoints to mutate your data. Instead, you write asynchronous functions that execute on the server and can be invoked from your Client or Server Components.

Security is a top priority for web applications, as they can be vulnerable to various threats. This is where Server Actions come in. They offer an effective security solution, protecting against different types of attacks, securing your data, and ensuring authorized access. Server Actions achieve this through techniques like POST requests, encrypted closures, strict input checks, error message hashing, and host restrictions, all working together to significantly enhance your app's safety.

## [Using forms with Server Actions](https://nextjs.org/learn/dashboard-app/mutating-data#using-forms-with-server-actions)

In React, you can use the `action` attribute in the `<form>` element to invoke actions. The action will automatically receive the native [FormData](https://developer.mozilla.org/en-US/docs/Web/API/FormData) object, containing the captured data.

For example:

```
<span><span>// Server Component</span></span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>// Action</span></span>
<span><span>  </span><span>async</span><span> </span><span>function</span><span> </span><span>create</span><span>(formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>    </span><span>'use server'</span><span>;</span></span>
<span> </span>
<span><span>    </span><span>// Logic to mutate data...</span></span>
<span><span>  }</span></span>
<span> </span>
<span><span>  </span><span>// Invoke the action using the "action" attribute</span></span>
<span><span>  </span><span>return</span><span> &lt;</span><span>form</span><span> </span><span>action</span><span>=</span><span>{create}&gt;...&lt;/</span><span>form</span><span>&gt;;</span></span>
<span><span>}</span></span>
```

An advantage of invoking a Server Action within a Server Component is progressive enhancement - forms work even if JavaScript is disabled on the client.

## [Next.js with Server Actions](https://nextjs.org/learn/dashboard-app/mutating-data#nextjs-with-server-actions)

Server Actions are also deeply integrated with Next.js [caching](https://nextjs.org/docs/app/building-your-application/caching). When a form is submitted through a Server Action, not only can you use the action to mutate data, but you can also revalidate the associated cache using APIs like `revalidatePath` and `revalidateTag`.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

What's one benefit of using a Server Actions?

Let's see how it all works together!

## [Creating an invoice](https://nextjs.org/learn/dashboard-app/mutating-data#creating-an-invoice)

Here are the steps you'll take to create a new invoice:

1.  Create a form to capture the user's input.
2.  Create a Server Action and invoke it from the form.
3.  Inside your Server Action, extract the data from the `formData` object.
4.  Validate and prepare the data to be inserted into your database.
5.  Insert the data and handle any errors.
6.  Revalidate the cache and redirect the user back to invoices page.

### [1\. Create a new route and form](https://nextjs.org/learn/dashboard-app/mutating-data#1-create-a-new-route-and-form)

To start, inside the `/invoices` folder, add a new route segment called `/create` with a `page.tsx` file:

![Invoices folder with a nested create folder, and a page.tsx file inside it](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fcreate-invoice-route.png&w=3840&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

You'll be using this route to create new invoices. Inside your `page.tsx` file, paste the following code, then spend some time studying it:

```
<span><span>import</span><span> Form </span><span>from</span><span> </span><span>'@/app/ui/invoices/create-form'</span><span>;</span></span>
<span><span>import</span><span> Breadcrumbs </span><span>from</span><span> </span><span>'@/app/ui/invoices/breadcrumbs'</span><span>;</span></span>
<span><span>import</span><span> { fetchCustomers } </span><span>from</span><span> </span><span>'@/app/lib/data'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>customers</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchCustomers</span><span>();</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>main</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>Breadcrumbs</span></span>
<span><span>        </span><span>breadcrumbs</span><span>=</span><span>{[</span></span>
<span><span>          { label</span><span>:</span><span> </span><span>'Invoices'</span><span>,</span><span> href</span><span>:</span><span> </span><span>'/</span><span>dashboard</span><span>/invoices'</span><span> }</span><span>,</span></span>
<span><span>          {</span></span>
<span><span>            label</span><span>:</span><span> </span><span>'Create Invoice'</span><span>,</span></span>
<span><span>            href</span><span>:</span><span> </span><span>'/</span><span>dashboard</span><span>/invoices/create'</span><span>,</span></span>
<span><span>            active</span><span>:</span><span> </span><span>true</span><span>,</span></span>
<span><span>          }</span><span>,</span></span>
<span><span>        ]}</span></span>
<span><span>      /&gt;</span></span>
<span><span>      &lt;</span><span>Form</span><span> </span><span>customers</span><span>=</span><span>{customers} /&gt;</span></span>
<span><span>    &lt;/</span><span>main</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Your page is a Server Component that fetches `customers` and passes it to the `<Form>` component. To save time, we've already created the `<Form>` component for you.

Navigate to the `<Form>` component, and you'll see that the form:

-   Has one `<select>` (dropdown) element with a list of **customers**.
-   Has one `<input>` element for the **amount** with `type="number"`.
-   Has two `<input>` elements for the status with `type="radio"`.
-   Has one button with `type="submit"`.

On [http://localhost:3000/dashboard/invoices/create](http://localhost:3000/dashboard/invoices/create), you should see the following UI:

![Create invoices page with breadcrumbs and form](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fcreate-invoice-page.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

### [2\. Create a Server Action](https://nextjs.org/learn/dashboard-app/mutating-data#2-create-a-server-action)

Great, now let's create a Server Action that is going to be called when the form is submitted.

Navigate to your `lib` directory and create a new file named `actions.ts`. At the top of this file, add the React [`use server`](https://react.dev/reference/react/use-server) directive:

By adding the `'use server'`, you mark all the exported functions within the file as Server Actions. These server functions can then be imported and used in Client and Server components.

You can also write Server Actions directly inside Server Components by adding `"use server"` inside the action. But for this course, we'll keep them all organized in a separate file.

In your `actions.ts` file, create a new async function that accepts `formData`:

```
<span><span>'use server'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(formData</span><span>:</span><span> </span><span>FormData</span><span>) {}</span></span>
```

Then, in your `<Form>` component, import the `createInvoice` from your `actions.ts` file. Add a `action` attribute to the `<form>` element, and call the `createInvoice` action.

```
<span><span>import</span><span> { customerField } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/definitions'</span><span>;</span></span>
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span><span>import</span><span> {</span></span>
<span><span>  CheckIcon</span><span>,</span></span>
<span><span>  ClockIcon</span><span>,</span></span>
<span><span>  CurrencyDollarIcon</span><span>,</span></span>
<span><span>  UserCircleIcon</span><span>,</span></span>
<span><span>} </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> { Button } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/button'</span><span>;</span></span>
<span><span>import</span><span> { createInvoice } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/actions'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Form</span><span>({</span></span>
<span><span>  customers</span><span>,</span></span>
<span><span>}</span><span>:</span><span> {</span></span>
<span><span>  customers</span><span>:</span><span> </span><span>customerField</span><span>[];</span></span>
<span><span>}) {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>form</span><span> </span><span>action</span><span>=</span><span>{createInvoice}&gt;</span></span>
<span><span>      // ...</span></span>
<span><span>  )</span></span>
<span><span>}</span></span>
```

> **Good to know**: In HTML, you'd pass a URL to the `action` attribute. This URL would be the destination where your form data should be submitted (usually an API endpoint).
> 
> However, in React, the `action` attribute is considered a special prop - meaning React builds on top of it to allow actions to be invoked.
> 
> Behind the scenes, Server Actions create a `POST` API endpoint. This is why you don't need to create API endpoints manually when using Server Actions.

Back in your `actions.ts` file, you'll need to extract the values of `formData`, there are a [couple of methods](https://developer.mozilla.org/en-US/docs/Web/API/FormData/append) you can use. For this example, let's use the [`.get(name)`](https://developer.mozilla.org/en-US/docs/Web/API/FormData/get) method.

```
<span><span>'use server'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>rawFormData</span><span> </span><span>=</span><span> {</span></span>
<span><span>    customerId</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'customerId'</span><span>)</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'amount'</span><span>)</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'status'</span><span>)</span><span>,</span></span>
<span><span>  };</span></span>
<span><span>  </span><span>// Test it out:</span></span>
<span><span>  </span><span>console</span><span>.log</span><span>(rawFormData);</span></span>
<span><span>}</span></span>
```

> **Tip:** If you're working with forms that have many fields, you may want to consider using the [`entries()`](https://developer.mozilla.org/en-US/docs/Web/API/FormData/entries) method with JavaScript's [`Object.fromEntries()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/fromEntries). For example:
> 
> `const rawFormData = Object.fromEntries(formData.entries())`

To check everything is connected correctly, go ahead and try out the form. After submitting, you should see the data you just entered into the form logged in your terminal.

Now that your data is in the shape of an object, it'll be much easier to work with.

### [4\. Validate and prepare the data](https://nextjs.org/learn/dashboard-app/mutating-data#4-validate-and-prepare-the-data)

Before sending the form data to your database, you want to ensure it's in the correct format and with the correct types. If you remember from earlier in the course, your invoices table expects data in the following format:

```
<span><span>export</span><span> </span><span>type</span><span> </span><span>Invoice</span><span> </span><span>=</span><span> {</span></span>
<span><span>  id</span><span>:</span><span> </span><span>string</span><span>; </span><span>// Will be created on the database</span></span>
<span><span>  customer_id</span><span>:</span><span> </span><span>string</span><span>;</span></span>
<span><span>  amount</span><span>:</span><span> </span><span>number</span><span>; </span><span>// Stored in cents</span></span>
<span><span>  status</span><span>:</span><span> </span><span>'pending'</span><span> </span><span>|</span><span> </span><span>'paid'</span><span>;</span></span>
<span><span>  date</span><span>:</span><span> </span><span>string</span><span>;</span></span>
<span><span>};</span></span>
```

So far, you only have the `customer_id`, `amount`, and `status` from the form.

#### [Type validation and coercion](https://nextjs.org/learn/dashboard-app/mutating-data#type-validation-and-coercion)

It's important to validate that the data from your form aligns with the expected types in your database. For instance, if you add a `console.log` inside your action:

```
<span><span>console</span><span>.log</span><span>(</span><span>typeof</span><span> </span><span>rawFormData</span><span>.amount);</span></span>
```

You'll notice that `amount` is of type `string` and not `number`. This is because `input` elements with `type="number"` actually return a string, not a number!

To handle type validation, you have a few options. While you can manually validate types, using a type validation library can save you time and effort. For your example, we'll use [Zod](https://zod.dev/), a TypeScript-first validation library that can simplify this task for you.

In your `actions.ts` file, import Zod and define a schema that matches the shape of your form object. This schema will validate the `formData` before saving it to a database.

```
<span><span>'use server'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { z } </span><span>from</span><span> </span><span>'zod'</span><span>;</span></span>
<span> </span>
<span><span>const</span><span> </span><span>FormSchema</span><span> </span><span>=</span><span> </span><span>z</span><span>.object</span><span>({</span></span>
<span><span>  id</span><span>:</span><span> </span><span>z</span><span>.string</span><span>()</span><span>,</span></span>
<span><span>  customerId</span><span>:</span><span> </span><span>z</span><span>.string</span><span>()</span><span>,</span></span>
<span><span>  amount</span><span>:</span><span> </span><span>z</span><span>.</span><span>coerce</span><span>.number</span><span>()</span><span>,</span></span>
<span><span>  status</span><span>:</span><span> </span><span>z</span><span>.enum</span><span>([</span><span>'pending'</span><span>,</span><span> </span><span>'paid'</span><span>])</span><span>,</span></span>
<span><span>  date</span><span>:</span><span> </span><span>z</span><span>.string</span><span>()</span><span>,</span></span>
<span><span>});</span></span>
<span> </span>
<span><span>const</span><span> </span><span>CreateInvoice</span><span> </span><span>=</span><span> </span><span>FormSchema</span><span>.omit</span><span>({ id</span><span>:</span><span> </span><span>true</span><span>,</span><span> date</span><span>:</span><span> </span><span>true</span><span> });</span></span>
<span> </span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

The `amount` field is specifically set to coerce (change) from a string to a number while also validating its type.

You can then pass your `rawFormData` to `CreateInvoice` to validate the types:

```
<span><span>// ...</span></span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>const</span><span> { </span><span>customerId</span><span>,</span><span> </span><span>amount</span><span>,</span><span> </span><span>status</span><span> } </span><span>=</span><span> </span><span>CreateInvoice</span><span>.parse</span><span>({</span></span>
<span><span>    customerId</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'customerId'</span><span>)</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'amount'</span><span>)</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'status'</span><span>)</span><span>,</span></span>
<span><span>  });</span></span>
<span><span>}</span></span>
```

#### [Storing values in cents](https://nextjs.org/learn/dashboard-app/mutating-data#storing-values-in-cents)

It's usually good practice to store monetary values in cents in your database to eliminate JavaScript floating-point errors and ensure greater accuracy.

Let's convert the amount into cents:

```
<span><span>// ...</span></span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>const</span><span> { </span><span>customerId</span><span>,</span><span> </span><span>amount</span><span>,</span><span> </span><span>status</span><span> } </span><span>=</span><span> </span><span>CreateInvoice</span><span>.parse</span><span>({</span></span>
<span><span>    customerId</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'customerId'</span><span>)</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'amount'</span><span>)</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'status'</span><span>)</span><span>,</span></span>
<span><span>  });</span></span>
<span><span>  </span><span>const</span><span> </span><span>amountInCents</span><span> </span><span>=</span><span> amount </span><span>*</span><span> </span><span>100</span><span>;</span></span>
<span><span>}</span></span>
```

#### [Creating new dates](https://nextjs.org/learn/dashboard-app/mutating-data#creating-new-dates)

Finally, let's create a new date with the format "YYYY-MM-DD" for the invoice's creation date:

```
<span><span>// ...</span></span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>const</span><span> { </span><span>customerId</span><span>,</span><span> </span><span>amount</span><span>,</span><span> </span><span>status</span><span> } </span><span>=</span><span> </span><span>CreateInvoice</span><span>.parse</span><span>({</span></span>
<span><span>    customerId</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'customerId'</span><span>)</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'amount'</span><span>)</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'status'</span><span>)</span><span>,</span></span>
<span><span>  });</span></span>
<span><span>  </span><span>const</span><span> </span><span>amountInCents</span><span> </span><span>=</span><span> amount </span><span>*</span><span> </span><span>100</span><span>;</span></span>
<span><span>  </span><span>const</span><span> </span><span>date</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>Date</span><span>()</span><span>.toISOString</span><span>()</span><span>.split</span><span>(</span><span>'T'</span><span>)[</span><span>0</span><span>];</span></span>
<span><span>}</span></span>
```

### [5\. Inserting the data into your database](https://nextjs.org/learn/dashboard-app/mutating-data#5-inserting-the-data-into-your-database)

Now that you have all the values you need for your database, you can create an SQL query to insert the new invoice into your database and pass in the variables:

```
<span><span>import</span><span> { z } </span><span>from</span><span> </span><span>'zod'</span><span>;</span></span>
<span><span>import</span><span> { sql } </span><span>from</span><span> </span><span>'@vercel/postgres'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>const</span><span> { </span><span>customerId</span><span>,</span><span> </span><span>amount</span><span>,</span><span> </span><span>status</span><span> } </span><span>=</span><span> </span><span>CreateInvoice</span><span>.parse</span><span>({</span></span>
<span><span>    customerId</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'customerId'</span><span>)</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'amount'</span><span>)</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'status'</span><span>)</span><span>,</span></span>
<span><span>  });</span></span>
<span><span>  </span><span>const</span><span> </span><span>amountInCents</span><span> </span><span>=</span><span> amount </span><span>*</span><span> </span><span>100</span><span>;</span></span>
<span><span>  </span><span>const</span><span> </span><span>date</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>Date</span><span>()</span><span>.toISOString</span><span>()</span><span>.split</span><span>(</span><span>'T'</span><span>)[</span><span>0</span><span>];</span></span>
<span> </span>
<span><span>  </span><span>await</span><span> </span><span>sql</span><span>`</span></span>
<span><span>    INSERT INTO invoices (customer_id, amount, status, date)</span></span>
<span><span>    VALUES (</span><span>${</span><span>customerId</span><span>}</span><span>, </span><span>${</span><span>amountInCents</span><span>}</span><span>, </span><span>${</span><span>status</span><span>}</span><span>, </span><span>${</span><span>date</span><span>}</span><span>)</span></span>
<span><span>  `</span><span>;</span></span>
<span><span>}</span></span>
```

Right now, we're not handling any errors. We'll do it in the next chapter. For now, let's move on to the next step.

### [6\. Revalidate and redirect](https://nextjs.org/learn/dashboard-app/mutating-data#6-revalidate-and-redirect)

Next.js has a [Client-side Router Cache](https://nextjs.org/docs/app/building-your-application/caching#router-cache) that stores the route segments in the user's browser for a time. Along with [prefetching](https://nextjs.org/docs/app/building-your-application/routing/linking-and-navigating#1-prefetching), this cache ensures that users can quickly navigate between routes while reducing the number of requests made to the server.

Since you're updating the data displayed in the invoices route, you want to clear this cache and trigger a new request to the server. You can do this with the [`revalidatePath`](https://nextjs.org/docs/app/api-reference/functions/revalidatePath) function from Next.js:

```
<span><span>'use server'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { z } </span><span>from</span><span> </span><span>'zod'</span><span>;</span></span>
<span><span>import</span><span> { sql } </span><span>from</span><span> </span><span>'@vercel/postgres'</span><span>;</span></span>
<span><span>import</span><span> { revalidatePath } </span><span>from</span><span> </span><span>'next/cache'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>const</span><span> { </span><span>customerId</span><span>,</span><span> </span><span>amount</span><span>,</span><span> </span><span>status</span><span> } </span><span>=</span><span> </span><span>CreateInvoice</span><span>.parse</span><span>({</span></span>
<span><span>    customerId</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'customerId'</span><span>)</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'amount'</span><span>)</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'status'</span><span>)</span><span>,</span></span>
<span><span>  });</span></span>
<span><span>  </span><span>const</span><span> </span><span>amountInCents</span><span> </span><span>=</span><span> amount </span><span>*</span><span> </span><span>100</span><span>;</span></span>
<span><span>  </span><span>const</span><span> </span><span>date</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>Date</span><span>()</span><span>.toISOString</span><span>()</span><span>.split</span><span>(</span><span>'T'</span><span>)[</span><span>0</span><span>];</span></span>
<span> </span>
<span><span>  </span><span>await</span><span> </span><span>sql</span><span>`</span></span>
<span><span>    INSERT INTO invoices (customer_id, amount, status, date)</span></span>
<span><span>    VALUES (</span><span>${</span><span>customerId</span><span>}</span><span>, </span><span>${</span><span>amountInCents</span><span>}</span><span>, </span><span>${</span><span>status</span><span>}</span><span>, </span><span>${</span><span>date</span><span>}</span><span>)</span></span>
<span><span>  `</span><span>;</span></span>
<span> </span>
<span><span>  </span><span>revalidatePath</span><span>(</span><span>'/dashboard/invoices'</span><span>);</span></span>
<span><span>}</span></span>
```

Once the database has been updated, the `/dashboard/invoices` path will be revalidated, and fresh data will be fetched from the server.

At this point, you also want to redirect the user back to the `/dashboard/invoices` page. You can do this with the [`redirect`](https://nextjs.org/docs/app/api-reference/functions/redirect) function from Next.js:

```
<span><span>'use server'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { z } </span><span>from</span><span> </span><span>'zod'</span><span>;</span></span>
<span><span>import</span><span> { sql } </span><span>from</span><span> </span><span>'@vercel/postgres'</span><span>;</span></span>
<span><span>import</span><span> { revalidatePath } </span><span>from</span><span> </span><span>'next/cache'</span><span>;</span></span>
<span><span>import</span><span> { redirect } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>// ...</span></span>
<span> </span>
<span><span>  </span><span>revalidatePath</span><span>(</span><span>'/dashboard/invoices'</span><span>);</span></span>
<span><span>  </span><span>redirect</span><span>(</span><span>'/dashboard/invoices'</span><span>);</span></span>
<span><span>}</span></span>
```

Congratulations! You've just implemented your first Server Action. Test it out by adding a new invoice, if everything is working correctly:

1.  You should be redirected to the `/dashboard/invoices` route on submission.
2.  You should see the new invoice at the top of the table.

## [Updating an invoice](https://nextjs.org/learn/dashboard-app/mutating-data#updating-an-invoice)

The updating invoice form is similar to the create an invoice form, except you'll need to pass the invoice `id` to update the record in your database. Let's see how you can get and pass the invoice `id`.

These are the steps you'll take to update an invoice:

1.  Create a new dynamic route segment with the invoice `id`.
2.  Read the invoice `id` from the page params.
3.  Fetch the specific invoice from your database.
4.  Pre-populate the form with the invoice data.
5.  Update the invoice data in your database.

### [1\. Create a Dynamic Route Segment with the invoice `id`](https://nextjs.org/learn/dashboard-app/mutating-data#1-create-a-dynamic-route-segment-with-the-invoice-id)

Next.js allows you to create [Dynamic Route Segments](https://nextjs.org/docs/app/building-your-application/routing/dynamic-routes) when you don't know the exact segment name and want to create routes based on data. This could be blog post titles, product pages, etc. You can create dynamic route segments by wrapping a folder's name in square brackets. For example, `[id]`, `[post]` or `[slug]`.

In your `/invoices` folder, create a new dynamic route called `[id]`, then a new route called `edit` with a `page.tsx` file. Your file structure should look like this:

![Invoices folder with a nested [id] folder, and an edit folder inside it](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fedit-invoice-route.png&w=3840&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

In your `<Table>` component, notice there's a `<UpdateInvoice />` button that receives the invoice's `id` from the table records.

```
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>InvoicesTable</span><span>({</span></span>
<span><span>  query</span><span>,</span></span>
<span><span>  currentPage</span><span>,</span></span>
<span><span>}</span><span>:</span><span> {</span></span>
<span><span>  query</span><span>:</span><span> </span><span>string</span><span>;</span></span>
<span><span>  currentPage</span><span>:</span><span> </span><span>number</span><span>;</span></span>
<span><span>}) {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    </span><span>// ...</span></span>
<span><span>    &lt;</span><span>td</span><span> </span><span>className</span><span>=</span><span>"flex justify-end gap-2 whitespace-nowrap px-6 py-4 text-sm"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>UpdateInvoice</span><span> </span><span>id</span><span>=</span><span>{</span><span>invoice</span><span>.id} /&gt;</span></span>
<span><span>      &lt;</span><span>DeleteInvoice</span><span> </span><span>id</span><span>=</span><span>{</span><span>invoice</span><span>.id} /&gt;</span></span>
<span><span>    &lt;/</span><span>td</span><span>&gt;</span></span>
<span><span>    </span><span>// ...</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Navigate to your `<UpdateInvoice />` component, and update the `href` of the `Link` to accept the `id` prop. You can use template literals to link to a dynamic route segment:

```
<span><span>import</span><span> { PencilIcon</span><span>,</span><span> PlusIcon</span><span>,</span><span> TrashIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>function</span><span> </span><span>UpdateInvoice</span><span>({ id }</span><span>:</span><span> { id</span><span>:</span><span> </span><span>string</span><span> }) {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>Link</span></span>
<span><span>      </span><span>href</span><span>=</span><span>{</span><span>`/dashboard/invoices/</span><span>${</span><span>id</span><span>}</span><span>/edit`</span><span>}</span></span>
<span><span>      </span><span>className</span><span>=</span><span>"rounded-md border p-2 hover:bg-gray-100"</span></span>
<span><span>    &gt;</span></span>
<span><span>      &lt;</span><span>PencilIcon</span><span> </span><span>className</span><span>=</span><span>"w-5"</span><span> /&gt;</span></span>
<span><span>    &lt;/</span><span>Link</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

### [2\. Read the invoice `id` from page `params`](https://nextjs.org/learn/dashboard-app/mutating-data#2-read-the-invoice-id-from-page-params)

Back on your `<Page>` component, paste the following code:

```
<span><span>import</span><span> Form </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/invoices/edit-form'</span><span>;</span></span>
<span><span>import</span><span> Breadcrumbs </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/invoices/breadcrumbs'</span><span>;</span></span>
<span><span>import</span><span> { fetchCustomers } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/data'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>main</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>Breadcrumbs</span></span>
<span><span>        </span><span>breadcrumbs</span><span>=</span><span>{[</span></span>
<span><span>          { label</span><span>:</span><span> </span><span>'Invoices'</span><span>,</span><span> href</span><span>:</span><span> </span><span>'/dashboard/invoices'</span><span> }</span><span>,</span></span>
<span><span>          {</span></span>
<span><span>            label</span><span>:</span><span> </span><span>'Edit Invoice'</span><span>,</span></span>
<span><span>            href</span><span>:</span><span> </span><span>`/dashboard/invoices/</span><span>${</span><span>id</span><span>}</span><span>/edit`</span><span>,</span></span>
<span><span>            active</span><span>:</span><span> </span><span>true</span><span>,</span></span>
<span><span>          }</span><span>,</span></span>
<span><span>        ]}</span></span>
<span><span>      /&gt;</span></span>
<span><span>      &lt;</span><span>Form</span><span> </span><span>invoice</span><span>=</span><span>{invoice} </span><span>customers</span><span>=</span><span>{customers} /&gt;</span></span>
<span><span>    &lt;/</span><span>main</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Notice how it's similar to your `/create` invoice page, except it imports a different form (from the `edit-form.tsx` file). This form should be **pre-populated** with a `defaultValue` for the customer's name, invoice amount, and status. To pre-populate the form fields, you need to fetch the specific invoice using `id`.

In addition to `searchParams`, page components also accept a prop called `params` which you can use to access the `id`. Update your `<Page>` component to receive the prop:

```
<span><span>import</span><span> Form </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/invoices/edit-form'</span><span>;</span></span>
<span><span>import</span><span> Breadcrumbs </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/invoices/breadcrumbs'</span><span>;</span></span>
<span><span>import</span><span> { fetchCustomers } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/data'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>(props</span><span>:</span><span> { params</span><span>:</span><span> </span><span>Promise</span><span>&lt;{ id</span><span>:</span><span> </span><span>string</span><span> }&gt; }) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>params</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>props</span><span>.params;</span></span>
<span><span>  </span><span>const</span><span> </span><span>id</span><span> </span><span>=</span><span> </span><span>params</span><span>.id;</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

### [3\. Fetch the specific invoice](https://nextjs.org/learn/dashboard-app/mutating-data#3-fetch-the-specific-invoice)

Then:

-   Import a new function called `fetchInvoiceById` and pass the `id` as an argument.
-   Import `fetchCustomers` to fetch the customer names for the dropdown.

You can use `Promise.all` to fetch both the invoice and customers in parallel:

```
<span><span>import</span><span> Form </span><span>from</span><span> </span><span>'@/app/ui/invoices/edit-form'</span><span>;</span></span>
<span><span>import</span><span> Breadcrumbs </span><span>from</span><span> </span><span>'@/app/ui/invoices/breadcrumbs'</span><span>;</span></span>
<span><span>import</span><span> { fetchInvoiceById</span><span>,</span><span> fetchCustomers } </span><span>from</span><span> </span><span>'@/app/lib/data'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>(props</span><span>:</span><span> { params</span><span>:</span><span> </span><span>Promise</span><span>&lt;{ id</span><span>:</span><span> </span><span>string</span><span> }&gt; }) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>params</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>props</span><span>.params;</span></span>
<span><span>  </span><span>const</span><span> </span><span>id</span><span> </span><span>=</span><span> </span><span>params</span><span>.id;</span></span>
<span><span>  </span><span>const</span><span> [</span><span>invoice</span><span>,</span><span> </span><span>customers</span><span>] </span><span>=</span><span> </span><span>await</span><span> </span><span>Promise</span><span>.all</span><span>([</span></span>
<span><span>    </span><span>fetchInvoiceById</span><span>(id)</span><span>,</span></span>
<span><span>    </span><span>fetchCustomers</span><span>()</span><span>,</span></span>
<span><span>  ]);</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

You will see a temporary TS error for the `invoice` prop in your terminal because `invoice` could be potentially `undefined`. Don't worry about it for now, you'll resolve it in the next chapter when you add error handling.

Great! Now, test that everything is wired correctly. Visit [http://localhost:3000/dashboard/invoices](http://localhost:3000/dashboard/invoices) and click on the Pencil icon to edit an invoice. After navigation, you should see a form that is pre-populated with the invoice details:

![Edit invoices page with breadcrumbs and form](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fedit-invoice-page.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

The URL should also be updated with an `id` as follows: `http://localhost:3000/dashboard/invoice/uuid/edit`

> **UUIDs vs. Auto-incrementing Keys**
> 
> We use UUIDs instead of incrementing keys (e.g., 1, 2, 3, etc.). This makes the URL longer; however, UUIDs eliminate the risk of ID collision, are globally unique, and reduce the risk of enumeration attacks - making them ideal for large databases.
> 
> However, if you prefer cleaner URLs, you might prefer to use auto-incrementing keys.

### [4\. Pass the `id` to the Server Action](https://nextjs.org/learn/dashboard-app/mutating-data#4-pass-the-id-to-the-server-action)

Lastly, you want to pass the `id` to the Server Action so you can update the right record in your database. You **cannot** pass the `id` as an argument like so:

```
<span><span>// Passing an id as argument won't work</span></span>
<span><span>&lt;</span><span>form</span><span> </span><span>action</span><span>=</span><span>{</span><span>updateInvoice</span><span>(id)}&gt;</span></span>
```

Instead, you can pass `id` to the Server Action using JS `bind`. This will ensure that any values passed to the Server Action are encoded.

```
<span><span>// ...</span></span>
<span><span>import</span><span> { updateInvoice } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/actions'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>EditInvoiceForm</span><span>({</span></span>
<span><span>  invoice</span><span>,</span></span>
<span><span>  customers</span><span>,</span></span>
<span><span>}</span><span>:</span><span> {</span></span>
<span><span>  invoice</span><span>:</span><span> </span><span>InvoiceForm</span><span>;</span></span>
<span><span>  customers</span><span>:</span><span> </span><span>CustomerField</span><span>[];</span></span>
<span><span>}) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>updateInvoiceWithId</span><span> </span><span>=</span><span> </span><span>updateInvoice</span><span>.bind</span><span>(</span><span>null</span><span>,</span><span> </span><span>invoice</span><span>.id);</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>form</span><span> </span><span>action</span><span>=</span><span>{updateInvoiceWithId}&gt;</span></span>
<span><span>      &lt;</span><span>input</span><span> </span><span>type</span><span>=</span><span>"hidden"</span><span> </span><span>name</span><span>=</span><span>"id"</span><span> </span><span>value</span><span>=</span><span>{</span><span>invoice</span><span>.id} /&gt;</span></span>
<span><span>    &lt;/</span><span>form</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

> **Note:** Using a hidden input field in your form also works (e.g. `<input type="hidden" name="id" value={invoice.id} />`). However, the values will appear as full text in the HTML source, which is not ideal for sensitive data like IDs.

Then, in your `actions.ts` file, create a new action, `updateInvoice`:

```
<span><span>// Use Zod to update the expected types</span></span>
<span><span>const</span><span> </span><span>UpdateInvoice</span><span> </span><span>=</span><span> </span><span>FormSchema</span><span>.omit</span><span>({ id</span><span>:</span><span> </span><span>true</span><span>,</span><span> date</span><span>:</span><span> </span><span>true</span><span> });</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>updateInvoice</span><span>(id</span><span>:</span><span> </span><span>string</span><span>,</span><span> formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>const</span><span> { </span><span>customerId</span><span>,</span><span> </span><span>amount</span><span>,</span><span> </span><span>status</span><span> } </span><span>=</span><span> </span><span>UpdateInvoice</span><span>.parse</span><span>({</span></span>
<span><span>    customerId</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'customerId'</span><span>)</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'amount'</span><span>)</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'status'</span><span>)</span><span>,</span></span>
<span><span>  });</span></span>
<span> </span>
<span><span>  </span><span>const</span><span> </span><span>amountInCents</span><span> </span><span>=</span><span> amount </span><span>*</span><span> </span><span>100</span><span>;</span></span>
<span> </span>
<span><span>  </span><span>await</span><span> </span><span>sql</span><span>`</span></span>
<span><span>    UPDATE invoices</span></span>
<span><span>    SET customer_id = </span><span>${</span><span>customerId</span><span>}</span><span>, amount = </span><span>${</span><span>amountInCents</span><span>}</span><span>, status = </span><span>${</span><span>status</span><span>}</span></span>
<span><span>    WHERE id = </span><span>${</span><span>id</span><span>}</span></span>
<span><span>  `</span><span>;</span></span>
<span> </span>
<span><span>  </span><span>revalidatePath</span><span>(</span><span>'/dashboard/invoices'</span><span>);</span></span>
<span><span>  </span><span>redirect</span><span>(</span><span>'/dashboard/invoices'</span><span>);</span></span>
<span><span>}</span></span>
```

Similarly to the `createInvoice` action, here you are:

1.  Extracting the data from `formData`.
2.  Validating the types with Zod.
3.  Converting the amount to cents.
4.  Passing the variables to your SQL query.
5.  Calling `revalidatePath` to clear the client cache and make a new server request.
6.  Calling `redirect` to redirect the user to the invoice's page.

Test it out by editing an invoice. After submitting the form, you should be redirected to the invoices page, and the invoice should be updated.

## [Deleting an invoice](https://nextjs.org/learn/dashboard-app/mutating-data#deleting-an-invoice)

To delete an invoice using a Server Action, wrap the delete button in a `<form>` element and pass the `id` to the Server Action using `bind`:

```
<span><span>import</span><span> { deleteInvoice } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/actions'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>function</span><span> </span><span>DeleteInvoice</span><span>({ id }</span><span>:</span><span> { id</span><span>:</span><span> </span><span>string</span><span> }) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>deleteInvoiceWithId</span><span> </span><span>=</span><span> </span><span>deleteInvoice</span><span>.bind</span><span>(</span><span>null</span><span>,</span><span> id);</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>form</span><span> </span><span>action</span><span>=</span><span>{deleteInvoiceWithId}&gt;</span></span>
<span><span>      &lt;</span><span>button</span><span> </span><span>type</span><span>=</span><span>"submit"</span><span> </span><span>className</span><span>=</span><span>"rounded-md border p-2 hover:bg-gray-100"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>span</span><span> </span><span>className</span><span>=</span><span>"sr-only"</span><span>&gt;Delete&lt;/</span><span>span</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>TrashIcon</span><span> </span><span>className</span><span>=</span><span>"w-4"</span><span> /&gt;</span></span>
<span><span>      &lt;/</span><span>button</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>form</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Inside your `actions.ts` file, create a new action called `deleteInvoice`.

```
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>deleteInvoice</span><span>(id</span><span>:</span><span> </span><span>string</span><span>) {</span></span>
<span><span>  </span><span>await</span><span> </span><span>sql</span><span>`DELETE FROM invoices WHERE id = </span><span>${</span><span>id</span><span>}</span><span>`</span><span>;</span></span>
<span><span>  </span><span>revalidatePath</span><span>(</span><span>'/dashboard/invoices'</span><span>);</span></span>
<span><span>}</span></span>
```

Since this action is being called in the `/dashboard/invoices` path, you don't need to call `redirect`. Calling `revalidatePath` will trigger a new server request and re-render the table.

## [Further reading](https://nextjs.org/learn/dashboard-app/mutating-data#further-reading)

In this chapter, you learned how to use Server Actions to mutate data. You also learned how to use the `revalidatePath` API to revalidate the Next.js cache and `redirect` to redirect the user to a new page.

You can also read more about [security with Server Actions](https://nextjs.org/blog/security-nextjs-server-components-actions) for additional learning.