In the previous chapter, you learned how to mutate data using Server Actions. Let's see how you can handle errors _gracefully_ using JavaScript's `try/catch` statements and Next.js APIs.

In this chapter...

Here are the topics we’ll cover

How to use the special `error.tsx` file to catch errors in your route segments, and show a fallback UI to the user.

How to use the `notFound` function and `not-found` file to handle 404 errors (for resources that don’t exist).

## [Adding `try/catch` to Server Actions](https://nextjs.org/learn/dashboard-app/error-handling#adding-trycatch-to-server-actions)

First, let's add JavaScript's `try/catch` statements to your Server Actions to allow you to handle errors gracefully.

If you know how to do this, spend a few minutes updating your Server Actions, or you can copy the code below:

Note how `redirect` is being called outside of the `try/catch` block. This is because `redirect` works by throwing an error, which would be caught by the `catch` block. To avoid this, you can call `redirect` **after** `try/catch`. `redirect` would only be reachable if `try` is successful.

Now, let's check what happens when an error is thrown in your Server Action. You can do this by throwing an error earlier. For example, in the `deleteInvoice` action, throw an error at the top of the function:

```
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>deleteInvoice</span><span>(id</span><span>:</span><span> </span><span>string</span><span>) {</span></span>
<span><span>  </span><span>throw</span><span> </span><span>new</span><span> </span><span>Error</span><span>(</span><span>'Failed to Delete Invoice'</span><span>);</span></span>
<span> </span>
<span><span>  </span><span>// Unreachable code block</span></span>
<span><span>  </span><span>try</span><span> {</span></span>
<span><span>    </span><span>await</span><span> </span><span>sql</span><span>`DELETE FROM invoices WHERE id = </span><span>${</span><span>id</span><span>}</span><span>`</span><span>;</span></span>
<span><span>    </span><span>revalidatePath</span><span>(</span><span>'/dashboard/invoices'</span><span>);</span></span>
<span><span>    </span><span>return</span><span> { message</span><span>:</span><span> </span><span>'Deleted Invoice'</span><span> };</span></span>
<span><span>  } </span><span>catch</span><span> (error) {</span></span>
<span><span>    </span><span>return</span><span> { message</span><span>:</span><span> </span><span>'Database Error: Failed to Delete Invoice'</span><span> };</span></span>
<span><span>  }</span></span>
<span><span>}</span></span>
```

When you try to delete an invoice, you should see an error on localhost. Ensure that you remove this error after testing and before moving onto the next section.

Seeing these errors are helpful while developing as you can catch any potential problems early. However, you also want to show errors to the user to avoid an abrupt failure and allow your application to continue running.

This is where Next.js [`error.tsx`](https://nextjs.org/docs/app/api-reference/file-conventions/error) file comes in.

## [Handling all errors with `error.tsx`](https://nextjs.org/learn/dashboard-app/error-handling#handling-all-errors-with-errortsx)

The `error.tsx` file can be used to define a UI boundary for a route segment. It serves as a **catch-all** for unexpected errors and allows you to display a fallback UI to your users.

Inside your `/dashboard/invoices` folder, create a new file called `error.tsx` and paste the following code:

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { useEffect } </span><span>from</span><span> </span><span>'react'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Error</span><span>({</span></span>
<span><span>  error</span><span>,</span></span>
<span><span>  reset</span><span>,</span></span>
<span><span>}</span><span>:</span><span> {</span></span>
<span><span>  error</span><span>:</span><span> </span><span>Error</span><span> </span><span>&amp;</span><span> { digest</span><span>?:</span><span> </span><span>string</span><span> };</span></span>
<span><span>  </span><span>reset</span><span>:</span><span> () </span><span>=&gt;</span><span> </span><span>void</span><span>;</span></span>
<span><span>}) {</span></span>
<span><span>  </span><span>useEffect</span><span>(() </span><span>=&gt;</span><span> {</span></span>
<span><span>    </span><span>// Optionally log the error to an error reporting service</span></span>
<span><span>    </span><span>console</span><span>.error</span><span>(error);</span></span>
<span><span>  }</span><span>,</span><span> [error]);</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>main</span><span> </span><span>className</span><span>=</span><span>"flex h-full flex-col items-center justify-center"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>h2</span><span> </span><span>className</span><span>=</span><span>"text-center"</span><span>&gt;Something went wrong!&lt;/</span><span>h2</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>button</span></span>
<span><span>        </span><span>className</span><span>=</span><span>"mt-4 rounded-md bg-blue-500 px-4 py-2 text-sm text-white transition-colors hover:bg-blue-400"</span></span>
<span><span>        </span><span>onClick</span><span>=</span><span>{</span></span>
<span><span>          </span><span>// Attempt to recover by trying to re-render the invoices route</span></span>
<span><span>          () </span><span>=&gt;</span><span> </span><span>reset</span><span>()</span></span>
<span><span>        }</span></span>
<span><span>      &gt;</span></span>
<span><span>        Try again</span></span>
<span><span>      &lt;/</span><span>button</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>main</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

There are a few things you'll notice about the code above:

-   **"use client"** - `error.tsx` needs to be a Client Component.
-   It accepts two props:
    -   `error`: This object is an instance of JavaScript's native [`Error`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error) object.
    -   `reset`: This is a function to reset the error boundary. When executed, the function will try to re-render the route segment.

When you try to delete an invoice again, you should see the following UI:

![The error.tsx file showing the props it accepts](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Ferror-page.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

## [Handling 404 errors with the `notFound` function](https://nextjs.org/learn/dashboard-app/error-handling#handling-404-errors-with-the-notfound-function)

Another way you can handle errors gracefully is by using the `notFound` function. While `error.tsx` is useful for catching **all** errors, `notFound` can be used when you try to fetch a resource that doesn't exist.

For example, visit [http://localhost:3000/dashboard/invoices/2e94d1ed-d220-449f-9f11-f0bbceed9645/edit](http://localhost:3000/dashboard/invoices/2e94d1ed-d220-449f-9f11-f0bbceed9645/edit).

This is a fake UUID that doesn't exist in your database.

You'll immediately see `error.tsx` kicks in because this is a child route of `/invoices` where `error.tsx` is defined.

However, if you want to be more specific, you can show a 404 error to tell the user the resource they're trying to access hasn't been found.

You can confirm that the resource hasn't been found by going into your `fetchInvoiceById` function in `data.ts`, and console logging the returned `invoice`:

```
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>fetchInvoiceById</span><span>(id</span><span>:</span><span> </span><span>string</span><span>) {</span></span>
<span><span>  </span><span>noStore</span><span>();</span></span>
<span><span>  </span><span>try</span><span> {</span></span>
<span><span>    </span><span>// ...</span></span>
<span> </span>
<span><span>    </span><span>console</span><span>.log</span><span>(invoice); </span><span>// Invoice is an empty array []</span></span>
<span><span>    </span><span>return</span><span> invoice[</span><span>0</span><span>];</span></span>
<span><span>  } </span><span>catch</span><span> (error) {</span></span>
<span><span>    </span><span>console</span><span>.error</span><span>(</span><span>'Database Error:'</span><span>,</span><span> error);</span></span>
<span><span>    </span><span>throw</span><span> </span><span>new</span><span> </span><span>Error</span><span>(</span><span>'Failed to fetch invoice.'</span><span>);</span></span>
<span><span>  }</span></span>
<span><span>}</span></span>
```

Now that you know the invoice doesn't exist in your database, let's use `notFound` to handle it. Navigate to `/dashboard/invoices/[id]/edit/page.tsx`, and import `{ notFound }` from `'next/navigation'`.

Then, you can use a conditional to invoke `notFound` if the invoice doesn't exist:

```
<span><span>import</span><span> { fetchInvoiceById</span><span>,</span><span> fetchCustomers } </span><span>from</span><span> </span><span>'@/app/lib/data'</span><span>;</span></span>
<span><span>import</span><span> { updateInvoice } </span><span>from</span><span> </span><span>'@/app/lib/actions'</span><span>;</span></span>
<span><span>import</span><span> { notFound } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>(props</span><span>:</span><span> { params</span><span>:</span><span> </span><span>Promise</span><span>&lt;{ id</span><span>:</span><span> </span><span>string</span><span> }&gt; }) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>params</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>props</span><span>.params;</span></span>
<span><span>  </span><span>const</span><span> </span><span>id</span><span> </span><span>=</span><span> </span><span>params</span><span>.id;</span></span>
<span><span>  </span><span>const</span><span> [</span><span>invoice</span><span>,</span><span> </span><span>customers</span><span>] </span><span>=</span><span> </span><span>await</span><span> </span><span>Promise</span><span>.all</span><span>([</span></span>
<span><span>    </span><span>fetchInvoiceById</span><span>(id)</span><span>,</span></span>
<span><span>    </span><span>fetchCustomers</span><span>()</span><span>,</span></span>
<span><span>  ]);</span></span>
<span> </span>
<span><span>  </span><span>if</span><span> (</span><span>!</span><span>invoice) {</span></span>
<span><span>    </span><span>notFound</span><span>();</span></span>
<span><span>  }</span></span>
<span> </span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

Perfect! `<Page>` will now throw an error if a specific invoice is not found. To show an error UI to the user. Create a `not-found.tsx` file inside the `/edit` folder.

![The not-found.tsx file inside the edit folder](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fnot-found-file.png&w=3840&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

Then, inside the `not-found.tsx` file, paste the following the code:

```
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span><span>import</span><span> { FaceFrownIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>NotFound</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>main</span><span> </span><span>className</span><span>=</span><span>"flex h-full flex-col items-center justify-center gap-2"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>FaceFrownIcon</span><span> </span><span>className</span><span>=</span><span>"w-10 text-gray-400"</span><span> /&gt;</span></span>
<span><span>      &lt;</span><span>h2</span><span> </span><span>className</span><span>=</span><span>"text-xl font-semibold"</span><span>&gt;404 Not Found&lt;/</span><span>h2</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>p</span><span>&gt;Could not find the requested invoice.&lt;/</span><span>p</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>Link</span></span>
<span><span>        </span><span>href</span><span>=</span><span>"/</span><span>dashboard</span><span>/invoices"</span></span>
<span><span>        </span><span>className</span><span>=</span><span>"mt-4 rounded-md bg-blue-500 px-4 py-2 text-sm text-white transition-colors hover:bg-blue-400"</span></span>
<span><span>      &gt;</span></span>
<span><span>        Go Back</span></span>
<span><span>      &lt;/</span><span>Link</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>main</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Refresh the route, and you should now see the following UI:

![404 Not Found Page](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2F404-not-found-page.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

That's something to keep in mind, `notFound` will take precedence over `error.tsx`, so you can reach out for it when you want to handle more specific errors!

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

Which file in Next.js serves as a catch-all for unexpected errors in your route segments?

## [Further reading](https://nextjs.org/learn/dashboard-app/error-handling#further-reading)

To learn more about error handling in Next.js, check out the following documentation:

-   [Error Handling](https://nextjs.org/docs/app/building-your-application/routing/error-handling)
-   [`error.js` API Reference](https://nextjs.org/docs/app/api-reference/file-conventions/error)
-   [`notFound()` API Reference](https://nextjs.org/docs/app/api-reference/functions/not-found)
-   [`not-found.js` API Reference](https://nextjs.org/docs/app/api-reference/file-conventions/not-found)