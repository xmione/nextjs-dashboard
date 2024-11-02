In the previous chapter, you improved your dashboard's initial loading performance with streaming. Now let's move on to the `/invoices` page, and learn how to add search and pagination!

In this chapter...

Here are the topics we’ll cover

Learn how to use the Next.js APIs: `useSearchParams`, `usePathname`, and `useRouter`.

Implement search and pagination using URL search params.

## [Starting code](https://nextjs.org/learn/dashboard-app/adding-search-and-pagination#starting-code)

Inside your `/dashboard/invoices/page.tsx` file, paste the following code:

```
<span><span>import</span><span> Pagination </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/invoices/pagination'</span><span>;</span></span>
<span><span>import</span><span> Search </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/search'</span><span>;</span></span>
<span><span>import</span><span> Table </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/invoices/table'</span><span>;</span></span>
<span><span>import</span><span> { CreateInvoice } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/invoices/buttons'</span><span>;</span></span>
<span><span>import</span><span> { lusitana } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/fonts'</span><span>;</span></span>
<span><span>import</span><span> { InvoicesTableSkeleton } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/skeletons'</span><span>;</span></span>
<span><span>import</span><span> { Suspense } </span><span>from</span><span> </span><span>'react'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"w-full"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"flex w-full items-center justify-between"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>h1</span><span> </span><span>className</span><span>=</span><span>{</span><span>`</span><span>${</span><span>lusitana</span><span>.className</span><span>}</span><span> text-2xl`</span><span>}&gt;Invoices&lt;/</span><span>h1</span><span>&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"mt-4 flex items-center justify-between gap-2 md:mt-8"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>Search</span><span> </span><span>placeholder</span><span>=</span><span>"Search invoices..."</span><span> /&gt;</span></span>
<span><span>        &lt;</span><span>CreateInvoice</span><span> /&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      {</span><span>/*  &lt;Suspense key={query + currentPage} fallback={&lt;InvoicesTableSkeleton /&gt;}&gt;</span></span>
<span><span>        &lt;Table query={query} currentPage={currentPage} /&gt;</span></span>
<span><span>      &lt;/Suspense&gt; */</span><span>}</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"mt-5 flex w-full justify-center"</span><span>&gt;</span></span>
<span><span>        {</span><span>/* &lt;Pagination totalPages={totalPages} /&gt; */</span><span>}</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Spend some time familiarizing yourself with the page and the components you'll be working with:

1.  `<Search/>` allows users to search for specific invoices.
2.  `<Pagination/>` allows users to navigate between pages of invoices.
3.  `<Table/>` displays the invoices.

Your search functionality will span the client and the server. When a user searches for an invoice on the client, the URL params will be updated, data will be fetched on the server, and the table will re-render on the server with the new data.

## [Why use URL search params?](https://nextjs.org/learn/dashboard-app/adding-search-and-pagination#why-use-url-search-params)

As mentioned above, you'll be using URL search params to manage the search state. This pattern may be new if you're used to doing it with client side state.

There are a couple of benefits of implementing search with URL params:

-   **Bookmarkable and Shareable URLs**: Since the search parameters are in the URL, users can bookmark the current state of the application, including their search queries and filters, for future reference or sharing.
-   **Server-Side Rendering and Initial Load**: URL parameters can be directly consumed on the server to render the initial state, making it easier to handle server rendering.
-   **Analytics and Tracking**: Having search queries and filters directly in the URL makes it easier to track user behavior without requiring additional client-side logic.

## [Adding the search functionality](https://nextjs.org/learn/dashboard-app/adding-search-and-pagination#adding-the-search-functionality)

These are the Next.js client hooks that you'll use to implement the search functionality:

-   **`useSearchParams`**\- Allows you to access the parameters of the current URL. For example, the search params for this URL `/dashboard/invoices?page=1&query=pending` would look like this: `{page: '1', query: 'pending'}`.
-   **`usePathname`** - Lets you read the current URL's pathname. For example, for the route `/dashboard/invoices`, `usePathname` would return `'/dashboard/invoices'`.
-   **`useRouter`** - Enables navigation between routes within client components programmatically. There are [multiple methods](https://nextjs.org/docs/app/api-reference/functions/use-router#userouter) you can use.

Here's a quick overview of the implementation steps:

1.  Capture the user's input.
2.  Update the URL with the search params.
3.  Keep the URL in sync with the input field.
4.  Update the table to reflect the search query.

### [1\. Capture the user's input](https://nextjs.org/learn/dashboard-app/adding-search-and-pagination#1-capture-the-users-input)

Go into the `<Search>` Component (`/app/ui/search.tsx`), and you'll notice:

-   `"use client"` - This is a Client Component, which means you can use event listeners and hooks.
-   `<input>` - This is the search input.

Create a new `handleSearch` function, and add an `onChange` listener to the `<input>` element. `onChange` will invoke `handleSearch` whenever the input value changes.

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { MagnifyingGlassIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Search</span><span>({ placeholder }</span><span>:</span><span> { placeholder</span><span>:</span><span> </span><span>string</span><span> }) {</span></span>
<span><span>  </span><span>function</span><span> </span><span>handleSearch</span><span>(term</span><span>:</span><span> </span><span>string</span><span>) {</span></span>
<span><span>    </span><span>console</span><span>.log</span><span>(term);</span></span>
<span><span>  }</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"relative flex flex-1 flex-shrink-0"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>label</span><span> </span><span>htmlFor</span><span>=</span><span>"search"</span><span> </span><span>className</span><span>=</span><span>"sr-only"</span><span>&gt;</span></span>
<span><span>        Search</span></span>
<span><span>      &lt;/</span><span>label</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>input</span></span>
<span><span>        </span><span>className</span><span>=</span><span>"peer block w-full rounded-md border border-gray-200 py-[9px] pl-10 text-sm outline-2 placeholder:text-gray-500"</span></span>
<span><span>        </span><span>placeholder</span><span>=</span><span>{placeholder}</span></span>
<span><span>        </span><span>onChange</span><span>=</span><span>{(e) </span><span>=&gt;</span><span> {</span></span>
<span><span>          </span><span>handleSearch</span><span>(</span><span>e</span><span>.</span><span>target</span><span>.value);</span></span>
<span><span>        }}</span></span>
<span><span>      /&gt;</span></span>
<span><span>      &lt;</span><span>MagnifyingGlassIcon</span><span> </span><span>className</span><span>=</span><span>"absolute left-3 top-1/2 h-[18px] w-[18px] -translate-y-1/2 text-gray-500 peer-focus:text-gray-900"</span><span> /&gt;</span></span>
<span><span>    &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Test that it's working correctly by opening the console in your Developer Tools, then type into the search field. You should see the search term logged to the console.

Great! You're capturing the user's search input. Now, you need to update the URL with the search term.

### [2\. Update the URL with the search params](https://nextjs.org/learn/dashboard-app/adding-search-and-pagination#2-update-the-url-with-the-search-params)

Import the `useSearchParams` hook from `'next/navigation'`, and assign it to a variable:

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { MagnifyingGlassIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> { useSearchParams } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Search</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>searchParams</span><span> </span><span>=</span><span> </span><span>useSearchParams</span><span>();</span></span>
<span> </span>
<span><span>  </span><span>function</span><span> </span><span>handleSearch</span><span>(term</span><span>:</span><span> </span><span>string</span><span>) {</span></span>
<span><span>    </span><span>console</span><span>.log</span><span>(term);</span></span>
<span><span>  }</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

Inside `handleSearch,` create a new [`URLSearchParams`](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams) instance using your new `searchParams` variable.

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { MagnifyingGlassIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> { useSearchParams } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Search</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>searchParams</span><span> </span><span>=</span><span> </span><span>useSearchParams</span><span>();</span></span>
<span> </span>
<span><span>  </span><span>function</span><span> </span><span>handleSearch</span><span>(term</span><span>:</span><span> </span><span>string</span><span>) {</span></span>
<span><span>    </span><span>const</span><span> </span><span>params</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>URLSearchParams</span><span>(searchParams);</span></span>
<span><span>  }</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

`URLSearchParams` is a Web API that provides utility methods for manipulating the URL query parameters. Instead of creating a complex string literal, you can use it to get the params string like `?page=1&query=a`.

Next, `set` the params string based on the user’s input. If the input is empty, you want to `delete` it:

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { MagnifyingGlassIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> { useSearchParams } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Search</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>searchParams</span><span> </span><span>=</span><span> </span><span>useSearchParams</span><span>();</span></span>
<span> </span>
<span><span>  </span><span>function</span><span> </span><span>handleSearch</span><span>(term</span><span>:</span><span> </span><span>string</span><span>) {</span></span>
<span><span>    </span><span>const</span><span> </span><span>params</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>URLSearchParams</span><span>(searchParams);</span></span>
<span><span>    </span><span>if</span><span> (term) {</span></span>
<span><span>      </span><span>params</span><span>.set</span><span>(</span><span>'query'</span><span>,</span><span> term);</span></span>
<span><span>    } </span><span>else</span><span> {</span></span>
<span><span>      </span><span>params</span><span>.delete</span><span>(</span><span>'query'</span><span>);</span></span>
<span><span>    }</span></span>
<span><span>  }</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

Now that you have the query string. You can use Next.js's `useRouter` and `usePathname` hooks to update the URL.

Import `useRouter` and `usePathname` from `'next/navigation'`, and use the `replace` method from `useRouter()` inside `handleSearch`:

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { MagnifyingGlassIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> { useSearchParams</span><span>,</span><span> usePathname</span><span>,</span><span> useRouter } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Search</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>searchParams</span><span> </span><span>=</span><span> </span><span>useSearchParams</span><span>();</span></span>
<span><span>  </span><span>const</span><span> </span><span>pathname</span><span> </span><span>=</span><span> </span><span>usePathname</span><span>();</span></span>
<span><span>  </span><span>const</span><span> { </span><span>replace</span><span> } </span><span>=</span><span> </span><span>useRouter</span><span>();</span></span>
<span> </span>
<span><span>  </span><span>function</span><span> </span><span>handleSearch</span><span>(term</span><span>:</span><span> </span><span>string</span><span>) {</span></span>
<span><span>    </span><span>const</span><span> </span><span>params</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>URLSearchParams</span><span>(searchParams);</span></span>
<span><span>    </span><span>if</span><span> (term) {</span></span>
<span><span>      </span><span>params</span><span>.set</span><span>(</span><span>'query'</span><span>,</span><span> term);</span></span>
<span><span>    } </span><span>else</span><span> {</span></span>
<span><span>      </span><span>params</span><span>.delete</span><span>(</span><span>'query'</span><span>);</span></span>
<span><span>    }</span></span>
<span><span>    </span><span>replace</span><span>(</span><span>`</span><span>${</span><span>pathname</span><span>}</span><span>?</span><span>${</span><span>params</span><span>.toString</span><span>()</span><span>}</span><span>`</span><span>);</span></span>
<span><span>  }</span></span>
<span><span>}</span></span>
```

Here's a breakdown of what's happening:

-   `${pathname}` is the current path, in your case, `"/dashboard/invoices"`.
-   As the user types into the search bar, `params.toString()` translates this input into a URL-friendly format.
-   `replace(${pathname}?${params.toString()})` updates the URL with the user's search data. For example, `/dashboard/invoices?query=lee` if the user searches for "Lee".
-   The URL is updated without reloading the page, thanks to Next.js's client-side navigation (which you learned about in the chapter on [navigating between pages](https://nextjs.org/learn/dashboard-app/navigating-between-pages).

### [3\. Keeping the URL and input in sync](https://nextjs.org/learn/dashboard-app/adding-search-and-pagination#3-keeping-the-url-and-input-in-sync)

To ensure the input field is in sync with the URL and will be populated when sharing, you can pass a `defaultValue` to input by reading from `searchParams`:

```
<span><span>&lt;</span><span>input</span></span>
<span><span>  </span><span>className</span><span>=</span><span>"peer block w-full rounded-md border border-gray-200 py-[9px] pl-10 text-sm outline-2 placeholder:text-gray-500"</span></span>
<span><span>  </span><span>placeholder</span><span>=</span><span>{placeholder}</span></span>
<span><span>  </span><span>onChange</span><span>=</span><span>{(e) </span><span>=&gt;</span><span> {</span></span>
<span><span>    </span><span>handleSearch</span><span>(</span><span>e</span><span>.</span><span>target</span><span>.value);</span></span>
<span><span>  }}</span></span>
<span><span>  </span><span>defaultValue</span><span>=</span><span>{</span><span>searchParams</span><span>.get</span><span>(</span><span>'query'</span><span>)</span><span>?.toString</span><span>()}</span></span>
<span><span>/&gt;</span></span>
```

> **`defaultValue` vs. `value` / Controlled vs. Uncontrolled**
> 
> If you're using state to manage the value of an input, you'd use the `value` attribute to make it a controlled component. This means React would manage the input's state.
> 
> However, since you're not using state, you can use `defaultValue`. This means the native input will manage its own state. This is okay since you're saving the search query to the URL instead of state.

### [4\. Updating the table](https://nextjs.org/learn/dashboard-app/adding-search-and-pagination#4-updating-the-table)

Finally, you need to update the table component to reflect the search query.

Navigate back to the invoices page.

Page components [accept a prop called `searchParams`](https://nextjs.org/docs/app/api-reference/file-conventions/page), so you can pass the current URL params to the `<Table>` component.

```
<span><span>import</span><span> Pagination </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/invoices/pagination'</span><span>;</span></span>
<span><span>import</span><span> Search </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/search'</span><span>;</span></span>
<span><span>import</span><span> Table </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/invoices/table'</span><span>;</span></span>
<span><span>import</span><span> { CreateInvoice } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/invoices/buttons'</span><span>;</span></span>
<span><span>import</span><span> { lusitana } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/fonts'</span><span>;</span></span>
<span><span>import</span><span> { Suspense } </span><span>from</span><span> </span><span>'react'</span><span>;</span></span>
<span><span>import</span><span> { InvoicesTableSkeleton } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/skeletons'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>(props</span><span>:</span><span> {</span></span>
<span><span>  searchParams</span><span>?:</span><span> </span><span>Promise</span><span>&lt;{</span></span>
<span><span>    query</span><span>?:</span><span> </span><span>string</span><span>;</span></span>
<span><span>    page</span><span>?:</span><span> </span><span>string</span><span>;</span></span>
<span><span>  }&gt;;</span></span>
<span><span>}) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>searchParams</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>props</span><span>.searchParams;</span></span>
<span><span>  </span><span>const</span><span> </span><span>query</span><span> </span><span>=</span><span> </span><span>searchParams</span><span>?.query </span><span>||</span><span> </span><span>''</span><span>;</span></span>
<span><span>  </span><span>const</span><span> </span><span>currentPage</span><span> </span><span>=</span><span> </span><span>Number</span><span>(</span><span>searchParams</span><span>?.page) </span><span>||</span><span> </span><span>1</span><span>;</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"w-full"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"flex w-full items-center justify-between"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>h1</span><span> </span><span>className</span><span>=</span><span>{</span><span>`</span><span>${</span><span>lusitana</span><span>.className</span><span>}</span><span> text-2xl`</span><span>}&gt;Invoices&lt;/</span><span>h1</span><span>&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"mt-4 flex items-center justify-between gap-2 md:mt-8"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>Search</span><span> </span><span>placeholder</span><span>=</span><span>"Search invoices..."</span><span> /&gt;</span></span>
<span><span>        &lt;</span><span>CreateInvoice</span><span> /&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>Suspense</span><span> </span><span>key</span><span>=</span><span>{query </span><span>+</span><span> currentPage} </span><span>fallback</span><span>=</span><span>{&lt;</span><span>InvoicesTableSkeleton</span><span> /&gt;}&gt;</span></span>
<span><span>        &lt;</span><span>Table</span><span> </span><span>query</span><span>=</span><span>{query} </span><span>currentPage</span><span>=</span><span>{currentPage} /&gt;</span></span>
<span><span>      &lt;/</span><span>Suspense</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"mt-5 flex w-full justify-center"</span><span>&gt;</span></span>
<span><span>        {</span><span>/* &lt;Pagination totalPages={totalPages} /&gt; */</span><span>}</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

If you navigate to the `<Table>` Component, you'll see that the two props, `query` and `currentPage`, are passed to the `fetchFilteredInvoices()` function which returns the invoices that match the query.

```
<span><span>// ...</span></span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>InvoicesTable</span><span>({</span></span>
<span><span>  query</span><span>,</span></span>
<span><span>  currentPage</span><span>,</span></span>
<span><span>}</span><span>:</span><span> {</span></span>
<span><span>  query</span><span>:</span><span> </span><span>string</span><span>;</span></span>
<span><span>  currentPage</span><span>:</span><span> </span><span>number</span><span>;</span></span>
<span><span>}) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>invoices</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchFilteredInvoices</span><span>(query</span><span>,</span><span> currentPage);</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

With these changes in place, go ahead and test it out. If you search for a term, you'll update the URL, which will send a new request to the server, data will be fetched on the server, and only the invoices that match your query will be returned.

> **When to use the `useSearchParams()` hook vs. the `searchParams` prop?**
> 
> You might have noticed you used two different ways to extract search params. Whether you use one or the other depends on whether you're working on the client or the server.
> 
> -   `<Search>` is a Client Component, so you used the `useSearchParams()` hook to access the params from the client.
> -   `<Table>` is a Server Component that fetches its own data, so you can pass the `searchParams` prop from the page to the component.
> 
> As a general rule, if you want to read the params from the client, use the `useSearchParams()` hook as this avoids having to go back to the server.

### [Best practice: Debouncing](https://nextjs.org/learn/dashboard-app/adding-search-and-pagination#best-practice-debouncing)

Congratulations! You've implemented search with Next.js! But there's something you can do to optimize it.

Inside your `handleSearch` function, add the following `console.log`:

```
<span><span>function</span><span> </span><span>handleSearch</span><span>(term</span><span>:</span><span> </span><span>string</span><span>) {</span></span>
<span><span>  </span><span>console</span><span>.log</span><span>(</span><span>`Searching... </span><span>${</span><span>term</span><span>}</span><span>`</span><span>);</span></span>
<span> </span>
<span><span>  </span><span>const</span><span> </span><span>params</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>URLSearchParams</span><span>(searchParams);</span></span>
<span><span>  </span><span>if</span><span> (term) {</span></span>
<span><span>    </span><span>params</span><span>.set</span><span>(</span><span>'query'</span><span>,</span><span> term);</span></span>
<span><span>  } </span><span>else</span><span> {</span></span>
<span><span>    </span><span>params</span><span>.delete</span><span>(</span><span>'query'</span><span>);</span></span>
<span><span>  }</span></span>
<span><span>  </span><span>replace</span><span>(</span><span>`</span><span>${</span><span>pathname</span><span>}</span><span>?</span><span>${</span><span>params</span><span>.toString</span><span>()</span><span>}</span><span>`</span><span>);</span></span>
<span><span>}</span></span>
```

Then type "Delba" into your search bar and check the console in dev tools. What is happening?

```
<span><span>Searching.</span><span>..</span><span> </span><span>D</span></span>
<span><span>Searching.</span><span>..</span><span> </span><span>De</span></span>
<span><span>Searching.</span><span>..</span><span> </span><span>Del</span></span>
<span><span>Searching.</span><span>..</span><span> </span><span>Delb</span></span>
<span><span>Searching.</span><span>..</span><span> </span><span>Delba</span></span>
```

You're updating the URL on every keystroke, and therefore querying your database on every keystroke! This isn't a problem as our application is small, but imagine if your application had thousands of users, each sending a new request to your database on each keystroke.

**Debouncing** is a programming practice that limits the rate at which a function can fire. In our case, you only want to query the database when the user has stopped typing.

> **How Debouncing Works:**
> 
> 1.  **Trigger Event**: When an event that should be debounced (like a keystroke in the search box) occurs, a timer starts.
> 2.  **Wait**: If a new event occurs before the timer expires, the timer is reset.
> 3.  **Execution**: If the timer reaches the end of its countdown, the debounced function is executed.

You can implement debouncing in a few ways, including manually creating your own debounce function. To keep things simple, we'll use a library called [`use-debounce`](https://www.npmjs.com/package/use-debounce).

Install `use-debounce`:

In your `<Search>` Component, import a function called `useDebouncedCallback`:

```
<span><span>// ...</span></span>
<span><span>import</span><span> { useDebouncedCallback } </span><span>from</span><span> </span><span>'use-debounce'</span><span>;</span></span>
<span> </span>
<span><span>// Inside the Search Component...</span></span>
<span><span>const</span><span> </span><span>handleSearch</span><span> </span><span>=</span><span> </span><span>useDebouncedCallback</span><span>((term) </span><span>=&gt;</span><span> {</span></span>
<span><span>  </span><span>console</span><span>.log</span><span>(</span><span>`Searching... </span><span>${</span><span>term</span><span>}</span><span>`</span><span>);</span></span>
<span> </span>
<span><span>  </span><span>const</span><span> </span><span>params</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>URLSearchParams</span><span>(searchParams);</span></span>
<span><span>  </span><span>if</span><span> (term) {</span></span>
<span><span>    </span><span>params</span><span>.set</span><span>(</span><span>'query'</span><span>,</span><span> term);</span></span>
<span><span>  } </span><span>else</span><span> {</span></span>
<span><span>    </span><span>params</span><span>.delete</span><span>(</span><span>'query'</span><span>);</span></span>
<span><span>  }</span></span>
<span><span>  </span><span>replace</span><span>(</span><span>`</span><span>${</span><span>pathname</span><span>}</span><span>?</span><span>${</span><span>params</span><span>.toString</span><span>()</span><span>}</span><span>`</span><span>);</span></span>
<span><span>}</span><span>,</span><span> </span><span>300</span><span>);</span></span>
```

This function will wrap the contents of `handleSearch`, and only run the code after a specific time once the user has stopped typing (300ms).

Now type in your search bar again, and open the console in dev tools. You should see the following:

By debouncing, you can reduce the number of requests sent to your database, thus saving resources.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

What problem does debouncing solve in the search feature?

After introducing the search feature, you'll notice the table displays only 6 invoices at a time. This is because the `fetchFilteredInvoices()` function in `data.ts` returns a maximum of 6 invoices per page.

Adding pagination allows users to navigate through the different pages to view all the invoices. Let's see how you can implement pagination using URL params, just like you did with search.

Navigate to the `<Pagination/>` component and you'll notice that it's a Client Component. You don't want to fetch data on the client as this would expose your database secrets (remember, you're not using an API layer). Instead, you can fetch the data on the server, and pass it to the component as a prop.

In `/dashboard/invoices/page.tsx`, import a new function called `fetchInvoicesPages` and pass the `query` from `searchParams` as an argument:

```
<span><span>// ...</span></span>
<span><span>import</span><span> { fetchInvoicesPages } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/data'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>(</span></span>
<span><span>  props</span><span>:</span><span> {</span></span>
<span><span>    searchParams</span><span>?:</span><span> </span><span>Promise</span><span>&lt;{</span></span>
<span><span>      query</span><span>?:</span><span> </span><span>string</span><span>;</span></span>
<span><span>      page</span><span>?:</span><span> </span><span>string</span><span>;</span></span>
<span><span>    }&gt;;</span></span>
<span><span>  }</span></span>
<span><span>) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>searchParams</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>props</span><span>.searchParams;</span></span>
<span><span>  </span><span>const</span><span> </span><span>query</span><span> </span><span>=</span><span> </span><span>searchParams</span><span>?.query </span><span>||</span><span> </span><span>''</span><span>;</span></span>
<span><span>  </span><span>const</span><span> </span><span>currentPage</span><span> </span><span>=</span><span> </span><span>Number</span><span>(</span><span>searchParams</span><span>?.page) </span><span>||</span><span> </span><span>1</span><span>;</span></span>
<span> </span>
<span><span>  </span><span>const</span><span> </span><span>totalPages</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchInvoicesPages</span><span>(query);</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    </span><span>// ...</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

`fetchInvoicesPages` returns the total number of pages based on the search query. For example, if there are 12 invoices that match the search query, and each page displays 6 invoices, then the total number of pages would be 2.

Next, pass the `totalPages` prop to the `<Pagination/>` component:

```
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>(props</span><span>:</span><span> {</span></span>
<span><span>  searchParams</span><span>?:</span><span> </span><span>Promise</span><span>&lt;{</span></span>
<span><span>    query</span><span>?:</span><span> </span><span>string</span><span>;</span></span>
<span><span>    page</span><span>?:</span><span> </span><span>string</span><span>;</span></span>
<span><span>  }&gt;;</span></span>
<span><span>}) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>searchParams</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>props</span><span>.searchParams;</span></span>
<span><span>  </span><span>const</span><span> </span><span>query</span><span> </span><span>=</span><span> </span><span>searchParams</span><span>?.query </span><span>||</span><span> </span><span>''</span><span>;</span></span>
<span><span>  </span><span>const</span><span> </span><span>currentPage</span><span> </span><span>=</span><span> </span><span>Number</span><span>(</span><span>searchParams</span><span>?.page) </span><span>||</span><span> </span><span>1</span><span>;</span></span>
<span> </span>
<span><span>  </span><span>const</span><span> </span><span>totalPages</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchInvoicesPages</span><span>(query);</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"w-full"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"flex w-full items-center justify-between"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>h1</span><span> </span><span>className</span><span>=</span><span>{</span><span>`</span><span>${</span><span>lusitana</span><span>.className</span><span>}</span><span> text-2xl`</span><span>}&gt;Invoices&lt;/</span><span>h1</span><span>&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"mt-4 flex items-center justify-between gap-2 md:mt-8"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>Search</span><span> </span><span>placeholder</span><span>=</span><span>"Search invoices..."</span><span> /&gt;</span></span>
<span><span>        &lt;</span><span>CreateInvoice</span><span> /&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>Suspense</span><span> </span><span>key</span><span>=</span><span>{query </span><span>+</span><span> currentPage} </span><span>fallback</span><span>=</span><span>{&lt;</span><span>InvoicesTableSkeleton</span><span> /&gt;}&gt;</span></span>
<span><span>        &lt;</span><span>Table</span><span> </span><span>query</span><span>=</span><span>{query} </span><span>currentPage</span><span>=</span><span>{currentPage} /&gt;</span></span>
<span><span>      &lt;/</span><span>Suspense</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"mt-5 flex w-full justify-center"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>Pagination</span><span> </span><span>totalPages</span><span>=</span><span>{totalPages} /&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Navigate to the `<Pagination/>` component and import the `usePathname` and `useSearchParams` hooks. We will use this to get the current page and set the new page. Make sure to also uncomment the code in this component. Your application will break temporarily as you haven't implemented the `<Pagination/>` logic yet. Let's do that now!

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { ArrowLeftIcon</span><span>,</span><span> ArrowRightIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> clsx </span><span>from</span><span> </span><span>'clsx'</span><span>;</span></span>
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span><span>import</span><span> { generatePagination } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/utils'</span><span>;</span></span>
<span><span>import</span><span> { usePathname</span><span>,</span><span> useSearchParams } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Pagination</span><span>({ totalPages }</span><span>:</span><span> { totalPages</span><span>:</span><span> </span><span>number</span><span> }) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>pathname</span><span> </span><span>=</span><span> </span><span>usePathname</span><span>();</span></span>
<span><span>  </span><span>const</span><span> </span><span>searchParams</span><span> </span><span>=</span><span> </span><span>useSearchParams</span><span>();</span></span>
<span><span>  </span><span>const</span><span> </span><span>currentPage</span><span> </span><span>=</span><span> </span><span>Number</span><span>(</span><span>searchParams</span><span>.get</span><span>(</span><span>'page'</span><span>)) </span><span>||</span><span> </span><span>1</span><span>;</span></span>
<span> </span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

Next, create a new function inside the `<Pagination>` Component called `createPageURL`. Similarly to the search, you'll use `URLSearchParams` to set the new page number, and `pathName` to create the URL string.

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { ArrowLeftIcon</span><span>,</span><span> ArrowRightIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> clsx </span><span>from</span><span> </span><span>'clsx'</span><span>;</span></span>
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span><span>import</span><span> { generatePagination } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/utils'</span><span>;</span></span>
<span><span>import</span><span> { usePathname</span><span>,</span><span> useSearchParams } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Pagination</span><span>({ totalPages }</span><span>:</span><span> { totalPages</span><span>:</span><span> </span><span>number</span><span> }) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>pathname</span><span> </span><span>=</span><span> </span><span>usePathname</span><span>();</span></span>
<span><span>  </span><span>const</span><span> </span><span>searchParams</span><span> </span><span>=</span><span> </span><span>useSearchParams</span><span>();</span></span>
<span><span>  </span><span>const</span><span> </span><span>currentPage</span><span> </span><span>=</span><span> </span><span>Number</span><span>(</span><span>searchParams</span><span>.get</span><span>(</span><span>'page'</span><span>)) </span><span>||</span><span> </span><span>1</span><span>;</span></span>
<span> </span>
<span><span>  </span><span>const</span><span> </span><span>createPageURL</span><span> </span><span>=</span><span> (pageNumber</span><span>:</span><span> </span><span>number</span><span> </span><span>|</span><span> </span><span>string</span><span>) </span><span>=&gt;</span><span> {</span></span>
<span><span>    </span><span>const</span><span> </span><span>params</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>URLSearchParams</span><span>(searchParams);</span></span>
<span><span>    </span><span>params</span><span>.set</span><span>(</span><span>'page'</span><span>,</span><span> </span><span>pageNumber</span><span>.toString</span><span>());</span></span>
<span><span>    </span><span>return</span><span> </span><span>`</span><span>${</span><span>pathname</span><span>}</span><span>?</span><span>${</span><span>params</span><span>.toString</span><span>()</span><span>}</span><span>`</span><span>;</span></span>
<span><span>  };</span></span>
<span> </span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

Here's a breakdown of what's happening:

-   `createPageURL` creates an instance of the current search parameters.
-   Then, it updates the "page" parameter to the provided page number.
-   Finally, it constructs the full URL using the pathname and updated search parameters.

The rest of the `<Pagination>` component deals with styling and different states (first, last, active, disabled, etc). We won't go into detail for this course, but feel free to look through the code to see where `createPageURL` is being called.

Finally, when the user types a new search query, you want to reset the page number to 1. You can do this by updating the `handleSearch` function in your `<Search>` component:

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { MagnifyingGlassIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> { usePathname</span><span>,</span><span> useRouter</span><span>,</span><span> useSearchParams } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span><span>import</span><span> { useDebouncedCallback } </span><span>from</span><span> </span><span>'use-debounce'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Search</span><span>({ placeholder }</span><span>:</span><span> { placeholder</span><span>:</span><span> </span><span>string</span><span> }) {</span></span>
<span><span>  </span><span>const</span><span> </span><span>searchParams</span><span> </span><span>=</span><span> </span><span>useSearchParams</span><span>();</span></span>
<span><span>  </span><span>const</span><span> { </span><span>replace</span><span> } </span><span>=</span><span> </span><span>useRouter</span><span>();</span></span>
<span><span>  </span><span>const</span><span> </span><span>pathname</span><span> </span><span>=</span><span> </span><span>usePathname</span><span>();</span></span>
<span> </span>
<span><span>  </span><span>const</span><span> </span><span>handleSearch</span><span> </span><span>=</span><span> </span><span>useDebouncedCallback</span><span>((term) </span><span>=&gt;</span><span> {</span></span>
<span><span>    </span><span>const</span><span> </span><span>params</span><span> </span><span>=</span><span> </span><span>new</span><span> </span><span>URLSearchParams</span><span>(searchParams);</span></span>
<span><span>    </span><span>params</span><span>.set</span><span>(</span><span>'page'</span><span>,</span><span> </span><span>'1'</span><span>);</span></span>
<span><span>    </span><span>if</span><span> (term) {</span></span>
<span><span>      </span><span>params</span><span>.set</span><span>(</span><span>'query'</span><span>,</span><span> term);</span></span>
<span><span>    } </span><span>else</span><span> {</span></span>
<span><span>      </span><span>params</span><span>.delete</span><span>(</span><span>'query'</span><span>);</span></span>
<span><span>    }</span></span>
<span><span>    </span><span>replace</span><span>(</span><span>`</span><span>${</span><span>pathname</span><span>}</span><span>?</span><span>${</span><span>params</span><span>.toString</span><span>()</span><span>}</span><span>`</span><span>);</span></span>
<span><span>  }</span><span>,</span><span> </span><span>300</span><span>);</span></span>
<span> </span>
```

## [Summary](https://nextjs.org/learn/dashboard-app/adding-search-and-pagination#summary)

Congratulations! You've just implemented search and pagination using URL Params and Next.js APIs.

To summarize, in this chapter:

-   You've handled search and pagination with URL search parameters instead of client state.
-   You've fetched data on the server.
-   You're using the `useRouter` router hook for smoother, client-side transitions.

These patterns are different from what you may be used to when working with client-side React, but hopefully, you now better understand the benefits of using URL search params and lifting this state to the server.