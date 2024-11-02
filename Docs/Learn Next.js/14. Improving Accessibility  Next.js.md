In the previous chapter, we looked at how to catch errors (including 404 errors) and display a fallback to the user. However, we still need to discuss another piece of the puzzle: form validation. Let's see how to implement server-side validation with Server Actions, and how you can show form errors using React's [`useActionState`](https://react.dev/reference/react/useActionState) hook - while keeping accessibility in mind!

In this chapter...

Here are the topics we’ll cover

How to use `eslint-plugin-jsx-a11y` with Next.js to implement accessibility best practices.

How to implement server-side form validation.

How to use the React `useActionState` hook to handle form errors, and display them to the user.

## [What is accessibility?](https://nextjs.org/learn/dashboard-app/improving-accessibility#what-is-accessibility)

Accessibility refers to designing and implementing web applications that everyone can use, including those with disabilities. It's a vast topic that covers many areas, such as keyboard navigation, semantic HTML, images, colors, videos, etc.

While we won't go in-depth into accessibility in this course, we'll discuss the accessibility features available in Next.js and some common practices to make your applications more accessible.

> If you'd like to learn more about accessibility, we recommend the [Learn Accessibility](https://web.dev/learn/accessibility/) course by [web.dev](https://web.dev/).

## [Using the ESLint accessibility plugin in Next.js](https://nextjs.org/learn/dashboard-app/improving-accessibility#using-the-eslint-accessibility-plugin-in-nextjs)

Next.js includes the [`eslint-plugin-jsx-a11y`](https://www.npmjs.com/package/eslint-plugin-jsx-a11y) plugin in its ESLint config to help catch accessibility issues early. For example, this plugin warns if you have images without `alt` text, use the `aria-*` and `role` attributes incorrectly, and more.

Optionally, if you would like to try this out, add `next lint` as a script in your `package.json` file:

```
<span><span>"scripts"</span><span>: {</span></span>
<span><span>    </span><span>"build"</span><span>:</span><span> </span><span>"next build"</span><span>,</span></span>
<span><span>    </span><span>"dev"</span><span>:</span><span> </span><span>"next dev"</span><span>,</span></span>
<span><span>    </span><span>"start"</span><span>:</span><span> </span><span>"next start"</span><span>,</span></span>
<span><span>    </span><span>"lint"</span><span>:</span><span> </span><span>"next lint"</span></span>
<span><span>}</span><span>,</span></span>
```

Then run `pnpm lint` in your terminal:

This will guide you through installing and configuring ESLint for your project. If you were to run `pnpm lint` now, you should see the following output:

```
<span><span>✔ </span><span>No</span><span> </span><span>ESLint</span><span> </span><span>warnings</span><span> </span><span>or</span><span> </span><span>errors</span></span>
```

However, what would happen if you had an image without `alt` text? Let's find out!

Go to `/app/ui/invoices/table.tsx` and remove the `alt` prop from the image. You can use your editor's search feature to quickly find the `<Image>`:

```
<span><span>&lt;</span><span>Image</span></span>
<span><span>  </span><span>src</span><span>=</span><span>{</span><span>invoice</span><span>.image_url}</span></span>
<span><span>  </span><span>className</span><span>=</span><span>"rounded-full"</span></span>
<span><span>  </span><span>width</span><span>=</span><span>{</span><span>28</span><span>}</span></span>
<span><span>  </span><span>height</span><span>=</span><span>{</span><span>28</span><span>}</span></span>
<span><span>  </span><span>alt</span><span>=</span><span>{</span><span>`</span><span>${</span><span>invoice</span><span>.name</span><span>}</span><span>'s profile picture`</span><span>} </span><span>// Delete this line</span></span>
<span><span>/&gt;</span></span>
```

Now run `pnpm lint` again, and you should see the following warning:

```
<span><span>.</span><span>/app/ui/invoices/table.tsx</span></span>
<span><span>45</span><span>:</span><span>25</span><span>  Warning: Image elements must have an alt prop,</span></span>
<span><span>either </span><span>with</span><span> </span><span>meaningful</span><span> </span><span>text,</span><span> </span><span>or</span><span> </span><span>an</span><span> </span><span>empty</span><span> </span><span>string</span><span> </span><span>for</span><span> </span><span>decorative</span><span> </span><span>images.</span><span> </span><span>jsx-a11y/alt-text</span></span>
```

While adding and configuring a linter is not a required step, it can be helpful to catch accessibility issues in your development process.

## [Improving form accessibility](https://nextjs.org/learn/dashboard-app/improving-accessibility#improving-form-accessibility)

There are three things we're already doing to improve accessibility in our forms:

-   **Semantic HTML**: Using semantic elements (`<input>`, `<option>`, etc) instead of `<div>`. This allows assistive technologies (AT) to focus on the input elements and provide appropriate contextual information to the user, making the form easier to navigate and understand.
-   **Labelling**: Including `<label>` and the `htmlFor` attribute ensures that each form field has a descriptive text label. This improves AT support by providing context and also enhances usability by allowing users to click on the label to focus on the corresponding input field.
-   **Focus Outline**: The fields are properly styled to show an outline when they are in focus. This is critical for accessibility as it visually indicates the active element on the page, helping both keyboard and screen reader users to understand where they are on the form. You can verify this by pressing `tab`.

These practices lay a good foundation for making your forms more accessible to many users. However, they don't address **form validation** and **errors**.

## [Form validation](https://nextjs.org/learn/dashboard-app/improving-accessibility#form-validation)

Go to [http://localhost:3000/dashboard/invoices/create](http://localhost:3000/dashboard/invoices/create), and submit an empty form. What happens?

You get an error! This is because you're sending empty form values to your Server Action. You can prevent this by validating your form on the client or the server.

### [Client-Side validation](https://nextjs.org/learn/dashboard-app/improving-accessibility#client-side-validation)

There are a couple of ways you can validate forms on the client. The simplest would be to rely on the form validation provided by the browser by adding the `required` attribute to the `<input>` and `<select>` elements in your forms. For example:

```
<span><span>&lt;</span><span>input</span></span>
<span><span>  </span><span>id</span><span>=</span><span>"amount"</span></span>
<span><span>  </span><span>name</span><span>=</span><span>"amount"</span></span>
<span><span>  </span><span>type</span><span>=</span><span>"number"</span></span>
<span><span>  </span><span>placeholder</span><span>=</span><span>"Enter USD amount"</span></span>
<span><span>  </span><span>className</span><span>=</span><span>"peer block w-full rounded-md border border-gray-200 py-2 pl-10 text-sm outline-2 placeholder:text-gray-500"</span></span>
<span><span>  </span><span>required</span></span>
<span><span>/&gt;</span></span>
```

Submit the form again. The browser will display a warning if you try to submit a form with empty values.

This approach is generally okay because some ATs support browser validation.

An alternative to client-side validation is server-side validation. Let's see how you can implement it in the next section. For now, delete the `required` attributes if you added them.

### [Server-Side validation](https://nextjs.org/learn/dashboard-app/improving-accessibility#server-side-validation)

By validating forms on the server, you can:

-   Ensure your data is in the expected format before sending it to your database.
-   Reduce the risk of malicious users bypassing client-side validation.
-   Have one source of truth for what is considered _valid_ data.

In your `create-form.tsx` component, import the `useActionState` hook from `react`. Since `useActionState` is a hook, you will need to turn your form into a Client Component using `"use client"` directive:

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span><span>import</span><span> { useActionState } </span><span>from</span><span> </span><span>'react'</span><span>;</span></span>
```

Inside your Form Component, the `useActionState` hook:

-   Takes two arguments: `(action, initialState)`.
-   Returns two values: `[state, formAction]` - the form state, and a function to be called when the form is submitted.

Pass your `createInvoice` action as an argument of `useActionState`, and inside your `<form action={}>` attribute, call `formAction`.

```
<span><span>// ...</span></span>
<span><span>import</span><span> { useActionState } </span><span>from</span><span> </span><span>'react'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Form</span><span>({ customers }</span><span>:</span><span> { customers</span><span>:</span><span> </span><span>CustomerField</span><span>[] }) {</span></span>
<span><span>  </span><span>const</span><span> [</span><span>state</span><span>,</span><span> </span><span>formAction</span><span>] </span><span>=</span><span> </span><span>useActionState</span><span>(createInvoice</span><span>,</span><span> initialState);</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> &lt;</span><span>form</span><span> </span><span>action</span><span>=</span><span>{formAction}&gt;...&lt;/</span><span>form</span><span>&gt;;</span></span>
<span><span>}</span></span>
```

The `initialState` can be anything you define, in this case, create an object with two empty keys: `message` and `errors`, and import the `State` type from your `actions.ts` file:

```
<span><span>// ...</span></span>
<span><span>import</span><span> { createInvoice</span><span>,</span><span> State } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/actions'</span><span>;</span></span>
<span><span>import</span><span> { useActionState } </span><span>from</span><span> </span><span>'react'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Form</span><span>({ customers }</span><span>:</span><span> { customers</span><span>:</span><span> </span><span>CustomerField</span><span>[] }) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>initialState</span><span>:</span><span> </span><span>State</span><span> </span><span>=</span><span> { message</span><span>:</span><span> </span><span>null</span><span>,</span><span> errors</span><span>:</span><span> {} };</span></span>
<span><span>  </span><span>const</span><span> [</span><span>state</span><span>,</span><span> </span><span>formAction</span><span>] </span><span>=</span><span> </span><span>useActionState</span><span>(createInvoice</span><span>,</span><span> initialState);</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> &lt;</span><span>form</span><span> </span><span>action</span><span>=</span><span>{formAction}&gt;...&lt;/</span><span>form</span><span>&gt;;</span></span>
<span><span>}</span></span>
```

This may seem confusing initially, but it'll make more sense once you update the server action. Let's do that now.

In your `action.ts` file, you can use Zod to validate form data. Update your `FormSchema` as follows:

```
<span><span>const</span><span> </span><span>FormSchema</span><span> </span><span>=</span><span> </span><span>z</span><span>.object</span><span>({</span></span>
<span><span>  id</span><span>:</span><span> </span><span>z</span><span>.string</span><span>()</span><span>,</span></span>
<span><span>  customerId</span><span>:</span><span> </span><span>z</span><span>.string</span><span>({</span></span>
<span><span>    invalid_type_error</span><span>:</span><span> </span><span>'Please select a customer.'</span><span>,</span></span>
<span><span>  })</span><span>,</span></span>
<span><span>  amount</span><span>:</span><span> </span><span>z</span><span>.coerce</span></span>
<span><span>    </span><span>.number</span><span>()</span></span>
<span><span>    </span><span>.gt</span><span>(</span><span>0</span><span>,</span><span> { message</span><span>:</span><span> </span><span>'Please enter an amount greater than $0.'</span><span> })</span><span>,</span></span>
<span><span>  status</span><span>:</span><span> </span><span>z</span><span>.enum</span><span>([</span><span>'pending'</span><span>,</span><span> </span><span>'paid'</span><span>]</span><span>,</span><span> {</span></span>
<span><span>    invalid_type_error</span><span>:</span><span> </span><span>'Please select an invoice status.'</span><span>,</span></span>
<span><span>  })</span><span>,</span></span>
<span><span>  date</span><span>:</span><span> </span><span>z</span><span>.string</span><span>()</span><span>,</span></span>
<span><span>});</span></span>
```

-   `customerId` - Zod already throws an error if the customer field is empty as it expects a type `string`. But let's add a friendly message if the user doesn't select a customer.
-   `amount` - Since you are coercing the amount type from `string` to `number`, it'll default to zero if the string is empty. Let's tell Zod we always want the amount greater than 0 with the `.gt()` function.
-   `status` - Zod already throws an error if the status field is empty as it expects "pending" or "paid". Let's also add a friendly message if the user doesn't select a status.

Next, update your `createInvoice` action to accept two parameters - `prevState` and `formData`:

```
<span><span>export</span><span> </span><span>type</span><span> </span><span>State</span><span> </span><span>=</span><span> {</span></span>
<span><span>  errors</span><span>?:</span><span> {</span></span>
<span><span>    customerId</span><span>?:</span><span> </span><span>string</span><span>[];</span></span>
<span><span>    amount</span><span>?:</span><span> </span><span>string</span><span>[];</span></span>
<span><span>    status</span><span>?:</span><span> </span><span>string</span><span>[];</span></span>
<span><span>  };</span></span>
<span><span>  message</span><span>?:</span><span> </span><span>string</span><span> </span><span>|</span><span> </span><span>null</span><span>;</span></span>
<span><span>};</span></span>
<span> </span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(prevState</span><span>:</span><span> </span><span>State</span><span>,</span><span> formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

-   `formData` - same as before.
-   `prevState` - contains the state passed from the `useActionState` hook. You won't be using it in the action in this example, but it's a required prop.

Then, change the Zod `parse()` function to `safeParse()`:

```
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(prevState</span><span>:</span><span> </span><span>State</span><span>,</span><span> formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>// Validate form fields using Zod</span></span>
<span><span>  </span><span>const</span><span> </span><span>validatedFields</span><span> </span><span>=</span><span> </span><span>CreateInvoice</span><span>.safeParse</span><span>({</span></span>
<span><span>    customerId</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'customerId'</span><span>)</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'amount'</span><span>)</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'status'</span><span>)</span><span>,</span></span>
<span><span>  });</span></span>
<span> </span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

`safeParse()` will return an object containing either a `success` or `error` field. This will help handle validation more gracefully without having put this logic inside the `try/catch` block.

Before sending the information to your database, check if the form fields were validated correctly with a conditional:

```
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(prevState</span><span>:</span><span> </span><span>State</span><span>,</span><span> formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>// Validate form fields using Zod</span></span>
<span><span>  </span><span>const</span><span> </span><span>validatedFields</span><span> </span><span>=</span><span> </span><span>CreateInvoice</span><span>.safeParse</span><span>({</span></span>
<span><span>    customerId</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'customerId'</span><span>)</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'amount'</span><span>)</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'status'</span><span>)</span><span>,</span></span>
<span><span>  });</span></span>
<span> </span>
<span><span>  </span><span>// If form validation fails, return errors early. Otherwise, continue.</span></span>
<span><span>  </span><span>if</span><span> (</span><span>!</span><span>validatedFields</span><span>.success) {</span></span>
<span><span>    </span><span>return</span><span> {</span></span>
<span><span>      errors</span><span>:</span><span> </span><span>validatedFields</span><span>.</span><span>error</span><span>.flatten</span><span>().fieldErrors</span><span>,</span></span>
<span><span>      message</span><span>:</span><span> </span><span>'Missing Fields. Failed to Create Invoice.'</span><span>,</span></span>
<span><span>    };</span></span>
<span><span>  }</span></span>
<span> </span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

If `validatedFields` isn't successful, we return the function early with the error messages from Zod.

> **Tip:** console.log `validatedFields` and submit an empty form to see the shape of it.

Finally, since you're handling form validation separately, outside your try/catch block, you can return a specific message for any database errors, your final code should look like this:

```
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>createInvoice</span><span>(prevState</span><span>:</span><span> </span><span>State</span><span>,</span><span> formData</span><span>:</span><span> </span><span>FormData</span><span>) {</span></span>
<span><span>  </span><span>// Validate form using Zod</span></span>
<span><span>  </span><span>const</span><span> </span><span>validatedFields</span><span> </span><span>=</span><span> </span><span>CreateInvoice</span><span>.safeParse</span><span>({</span></span>
<span><span>    customerId</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'customerId'</span><span>)</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'amount'</span><span>)</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>formData</span><span>.get</span><span>(</span><span>'status'</span><span>)</span><span>,</span></span>
<span><span>  });</span></span>
<span> </span>
<span><span>  </span><span>// If form validation fails, return errors early. Otherwise, continue.</span></span>
<span><span>  </span><span>if</span><span> (</span><span>!</span><span>validatedFields</span><span>.success) {</span></span>
<span><span>    </span><span>return</span><span> {</span></span>
<span><span>      errors</span><span>:</span><span> </span><span>validatedFields</span><span>.</span><span>error</span><span>.flatten</span><span>().fieldErrors</span><span>,</span></span>
<span><span>      message</span><span>:</span><span> </span><span>'Missing Fields. Failed to Create Invoice.'</span><span>,</span></span>
<span><span>    };</span></span>
<span><span>  }</span></span>
<span> </span>
<span><span>  </span><span>// Prepare data for insertion into the database</span></span>
<span><span>  </span><span>const</span><span> { </span><span>customerId</span><span>,</span><span> </span><span>amount</span><span>,</span><span> </span><span>status</span><span> } </span><span>=</span><span> </span><span>validatedFields</span><span>.data;</span></span>
<span><span>  </span><span>const</span><span> </span><span>amountInCents</span><span> </span><span>=</span><span> amount </span><span>*</span><span> </span><span>100</span><span>;</span></span>
<span><span>  </span><span>const</span><span> </span><span>date</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>Date</span><span>()</span><span>.toISOString</span><span>()</span><span>.split</span><span>(</span><span>'T'</span><span>)[</span><span>0</span><span>];</span></span>
<span> </span>
<span><span>  </span><span>// Insert data into the database</span></span>
<span><span>  </span><span>try</span><span> {</span></span>
<span><span>    </span><span>await</span><span> </span><span>sql</span><span>`</span></span>
<span><span>      INSERT INTO invoices (customer_id, amount, status, date)</span></span>
<span><span>      VALUES (</span><span>${</span><span>customerId</span><span>}</span><span>, </span><span>${</span><span>amountInCents</span><span>}</span><span>, </span><span>${</span><span>status</span><span>}</span><span>, </span><span>${</span><span>date</span><span>}</span><span>)</span></span>
<span><span>    `</span><span>;</span></span>
<span><span>  } </span><span>catch</span><span> (error) {</span></span>
<span><span>    </span><span>// If a database error occurs, return a more specific error.</span></span>
<span><span>    </span><span>return</span><span> {</span></span>
<span><span>      message</span><span>:</span><span> </span><span>'Database Error: Failed to Create Invoice.'</span><span>,</span></span>
<span><span>    };</span></span>
<span><span>  }</span></span>
<span> </span>
<span><span>  </span><span>// Revalidate the cache for the invoices page and redirect the user.</span></span>
<span><span>  </span><span>revalidatePath</span><span>(</span><span>'/dashboard/invoices'</span><span>);</span></span>
<span><span>  </span><span>redirect</span><span>(</span><span>'/dashboard/invoices'</span><span>);</span></span>
<span><span>}</span></span>
```

Great, now let's display the errors in your form component. Back in the `create-form.tsx` component, you can access the errors using the form `state`.

Add a **ternary operator** that checks for each specific error. For example, after the customer's field, you can add:

```
<span><span>&lt;</span><span>form</span><span> </span><span>action</span><span>=</span><span>{formAction}&gt;</span></span>
<span><span>  &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"rounded-md bg-gray-50 p-4 md:p-6"</span><span>&gt;</span></span>
<span><span>    {</span><span>/* Customer Name */</span><span>}</span></span>
<span><span>    &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"mb-4"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>label</span><span> </span><span>htmlFor</span><span>=</span><span>"customer"</span><span> </span><span>className</span><span>=</span><span>"mb-2 block text-sm font-medium"</span><span>&gt;</span></span>
<span><span>        Choose customer</span></span>
<span><span>      &lt;/</span><span>label</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"relative"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>select</span></span>
<span><span>          </span><span>id</span><span>=</span><span>"customer"</span></span>
<span><span>          </span><span>name</span><span>=</span><span>"customerId"</span></span>
<span><span>          </span><span>className</span><span>=</span><span>"peer block w-full rounded-md border border-gray-200 py-2 pl-10 text-sm outline-2 placeholder:text-gray-500"</span></span>
<span><span>          </span><span>defaultValue</span><span>=</span><span>""</span></span>
<span><span>          </span><span>aria-describedby</span><span>=</span><span>"customer-error"</span></span>
<span><span>        &gt;</span></span>
<span><span>          &lt;</span><span>option</span><span> </span><span>value</span><span>=</span><span>""</span><span> </span><span>disabled</span><span>&gt;</span></span>
<span><span>            Select a customer</span></span>
<span><span>          &lt;/</span><span>option</span><span>&gt;</span></span>
<span><span>          {</span><span>customers</span><span>.map</span><span>((name) </span><span>=&gt;</span><span> (</span></span>
<span><span>            &lt;</span><span>option</span><span> </span><span>key</span><span>=</span><span>{</span><span>name</span><span>.id} </span><span>value</span><span>=</span><span>{</span><span>name</span><span>.id}&gt;</span></span>
<span><span>              {</span><span>name</span><span>.name}</span></span>
<span><span>            &lt;/</span><span>option</span><span>&gt;</span></span>
<span><span>          ))}</span></span>
<span><span>        &lt;/</span><span>select</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>UserCircleIcon</span><span> </span><span>className</span><span>=</span><span>"pointer-events-none absolute left-3 top-1/2 h-[18px] w-[18px] -translate-y-1/2 text-gray-500"</span><span> /&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>id</span><span>=</span><span>"customer-error"</span><span> </span><span>aria-live</span><span>=</span><span>"polite"</span><span> </span><span>aria-atomic</span><span>=</span><span>"true"</span><span>&gt;</span></span>
<span><span>        {</span><span>state</span><span>.</span><span>errors</span><span>?.customerId </span><span>&amp;&amp;</span></span>
<span><span>          </span><span>state</span><span>.</span><span>errors</span><span>.</span><span>customerId</span><span>.map</span><span>((error</span><span>:</span><span> </span><span>string</span><span>) </span><span>=&gt;</span><span> (</span></span>
<span><span>            &lt;</span><span>p</span><span> </span><span>className</span><span>=</span><span>"mt-2 text-sm text-red-500"</span><span> </span><span>key</span><span>=</span><span>{error}&gt;</span></span>
<span><span>              {error}</span></span>
<span><span>            &lt;/</span><span>p</span><span>&gt;</span></span>
<span><span>          ))}</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    // ...</span></span>
<span><span>  &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>&lt;/</span><span>form</span><span>&gt;</span></span>
```

> **Tip:** You can console.log `state` inside your component and check if everything is wired correctly. Check the console in Dev Tools as your form is now a Client Component.

In the code above, you're also adding the following aria labels:

-   `aria-describedby="customer-error"`: This establishes a relationship between the `select` element and the error message container. It indicates that the container with `id="customer-error"` describes the `select` element. Screen readers will read this description when the user interacts with the `select` box to notify them of errors.
-   `id="customer-error"`: This `id` attribute uniquely identifies the HTML element that holds the error message for the `select` input. This is necessary for `aria-describedby` to establish the relationship.
-   `aria-live="polite"`: The screen reader should politely notify the user when the error inside the `div` is updated. When the content changes (e.g. when a user corrects an error), the screen reader will announce these changes, but only when the user is idle so as not to interrupt them.

## [Practice: Adding aria labels](https://nextjs.org/learn/dashboard-app/improving-accessibility#practice-adding-aria-labels)

Using the example above, add errors to your remaining form fields. You should also show a message at the bottom of the form if any fields are missing. Your UI should look like this:

![Create invoice form showing error messages for each field.](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fform-validation-page.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

Once you're ready, run `pnpm lint` to check if you're using the aria labels correctly.

If you'd like to challenge yourself, take the knowledge you've learned in this chapter and add form validation to the `edit-form.tsx` component.

You'll need to:

-   Add `useActionState` to your `edit-form.tsx` component.
-   Edit the `updateInvoice` action to handle validation errors from Zod.
-   Display the errors in your component, and add aria labels to improve accessibility.

Once you're ready, expand the code snippet below to see the solution: