Now that you've created and seeded your database, let's discuss the different ways you can fetch data for your application, and build out your dashboard overview page.

In this chapter...

Here are the topics we’ll cover

Learn about some approaches to fetching data: APIs, ORMs, SQL, etc.

How Server Components can help you access back-end resources more securely.

What network waterfalls are.

How to implement parallel data fetching using a JavaScript Pattern.

## [Choosing how to fetch data](https://nextjs.org/learn/dashboard-app/fetching-data#choosing-how-to-fetch-data)

### [API layer](https://nextjs.org/learn/dashboard-app/fetching-data#api-layer)

APIs are an intermediary layer between your application code and database. There are a few cases where you might use an API:

-   If you're using 3rd party services that provide an API.
-   If you're fetching data from the client, you want to have an API layer that runs on the server to avoid exposing your database secrets to the client.

In Next.js, you can create API endpoints using [Route Handlers](https://nextjs.org/docs/app/building-your-application/routing/route-handlers).

### [Database queries](https://nextjs.org/learn/dashboard-app/fetching-data#database-queries)

When you're creating a full-stack application, you'll also need to write logic to interact with your database. For [relational databases](https://aws.amazon.com/relational-database/) like Postgres, you can do this with SQL or with an [ORM](https://vercel.com/docs/storage/vercel-postgres/using-an-orm).

There are a few cases where you have to write database queries:

-   When creating your API endpoints, you need to write logic to interact with your database.
-   If you are using React Server Components (fetching data on the server), you can skip the API layer, and query your database directly without risking exposing your database secrets to the client.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

In which of these scenarios should you not query your database directly?

Let's learn more about React Server Components.

### [Using Server Components to fetch data](https://nextjs.org/learn/dashboard-app/fetching-data#using-server-components-to-fetch-data)

By default, Next.js applications use **React Server Components**. Fetching data with Server Components is a relatively new approach and there are a few benefits of using them:

-   Server Components support promises, providing a simpler solution for asynchronous tasks like data fetching. You can use `async/await` syntax without reaching out for `useEffect`, `useState` or data fetching libraries.
-   Server Components execute on the server, so you can keep expensive data fetches and logic on the server and only send the result to the client.
-   As mentioned before, since Server Components execute on the server, you can query the database directly without an additional API layer.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

What's one advantage of using React Server Components to fetch data?

### [Using SQL](https://nextjs.org/learn/dashboard-app/fetching-data#using-sql)

For your dashboard project, you'll write database queries using the [Vercel Postgres SDK](https://vercel.com/docs/storage/vercel-postgres/sdk) and SQL. There are a few reasons why we'll be using SQL:

-   SQL is the industry standard for querying relational databases (e.g. ORMs generate SQL under the hood).
-   Having a basic understanding of SQL can help you understand the fundamentals of relational databases, allowing you to apply your knowledge to other tools.
-   SQL is versatile, allowing you to fetch and manipulate specific data.
-   The Vercel Postgres SDK provides protection against [SQL injections](https://vercel.com/docs/storage/vercel-postgres/sdk#preventing-sql-injections).

Don't worry if you haven't used SQL before - we have provided the queries for you.

Go to `/app/lib/data.ts`, here you'll see that we're importing the [`sql`](https://vercel.com/docs/storage/vercel-postgres/sdk#sql) function from `@vercel/postgres`. This function allows you to query your database:

```
<span><span>import</span><span> { sql } </span><span>from</span><span> </span><span>'@vercel/postgres'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
```

You can call `sql` inside any Server Component. But to allow you to navigate the components more easily, we've kept all the data queries in the `data.ts` file, and you can import them into the components.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

What does SQL allow you to do in terms of fetching data?

> **Note:** If you used your own database provider in Chapter 6, you'll need to update the database queries to work with your provider. You can find the queries in `/app/lib/data.ts`.

## [Fetching data for the dashboard overview page](https://nextjs.org/learn/dashboard-app/fetching-data#fetching-data-for-the-dashboard-overview-page)

Now that you understand different ways of fetching data, let's fetch data for the dashboard overview page. Navigate to `/app/dashboard/page.tsx`, paste the following code, and spend some time exploring it:

```
<span><span>import</span><span> { Card } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/cards'</span><span>;</span></span>
<span><span>import</span><span> RevenueChart </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/revenue-chart'</span><span>;</span></span>
<span><span>import</span><span> LatestInvoices </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/latest-invoices'</span><span>;</span></span>
<span><span>import</span><span> { lusitana } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/fonts'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>main</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>h1</span><span> </span><span>className</span><span>=</span><span>{</span><span>`</span><span>${</span><span>lusitana</span><span>.className</span><span>}</span><span> mb-4 text-xl md:text-2xl`</span><span>}&gt;</span></span>
<span><span>        Dashboard</span></span>
<span><span>      &lt;/</span><span>h1</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"grid gap-6 sm:grid-cols-2 lg:grid-cols-4"</span><span>&gt;</span></span>
<span><span>        {</span><span>/* &lt;Card title="Collected" value={totalPaidInvoices} type="collected" /&gt; */</span><span>}</span></span>
<span><span>        {</span><span>/* &lt;Card title="Pending" value={totalPendingInvoices} type="pending" /&gt; */</span><span>}</span></span>
<span><span>        {</span><span>/* &lt;Card title="Total Invoices" value={numberOfInvoices} type="invoices" /&gt; */</span><span>}</span></span>
<span><span>        {</span><span>/* &lt;Card</span></span>
<span><span>          title="Total Customers"</span></span>
<span><span>          value={numberOfCustomers}</span></span>
<span><span>          type="customers"</span></span>
<span><span>        /&gt; */</span><span>}</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"mt-6 grid grid-cols-1 gap-6 md:grid-cols-4 lg:grid-cols-8"</span><span>&gt;</span></span>
<span><span>        {</span><span>/* &lt;RevenueChart revenue={revenue}  /&gt; */</span><span>}</span></span>
<span><span>        {</span><span>/* &lt;LatestInvoices latestInvoices={latestInvoices} /&gt; */</span><span>}</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>main</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

In the code above:

-   Page is an **async** component. This allows you to use `await` to fetch data.
-   There are also 3 components which receive data: `<Card>`, `<RevenueChart>`, and `<LatestInvoices>`. They are currently commented out to prevent the application from erroring.

## [Fetching data for **`<RevenueChart/>`**](https://nextjs.org/learn/dashboard-app/fetching-data#fetching-data-for-revenuechart)

To fetch data for the `<RevenueChart/>` component, import the `fetchRevenue` function from `data.ts` and call it inside your component:

```
<span><span>import</span><span> { Card } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/cards'</span><span>;</span></span>
<span><span>import</span><span> RevenueChart </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/revenue-chart'</span><span>;</span></span>
<span><span>import</span><span> LatestInvoices </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/latest-invoices'</span><span>;</span></span>
<span><span>import</span><span> { lusitana } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/fonts'</span><span>;</span></span>
<span><span>import</span><span> { fetchRevenue } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/data'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>revenue</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchRevenue</span><span>();</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

Then, uncomment the `<RevenueChart/>` component, navigate to the component file (`/app/ui/dashboard/revenue-chart.tsx`) and uncomment the code inside it. Check your localhost, you should be able to see a chart that uses `revenue` data.

![Revenue chart showing the total revenue for the last 12 months](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Frecent-revenue.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

Let's continue importing some more data queries!

## [Fetching data for **`<LatestInvoices/>`**](https://nextjs.org/learn/dashboard-app/fetching-data#fetching-data-for-latestinvoices)

For the `<LatestInvoices />` component, we need to get the latest 5 invoices, sorted by date.

You could fetch all the invoices and sort through them using JavaScript. This isn't a problem as our data is small, but as your application grows, it can significantly increase the amount of data transferred on each request and the JavaScript required to sort through it.

Instead of sorting through the latest invoices in-memory, you can use an SQL query to fetch only the last 5 invoices. For example, this is the SQL query from your `data.ts` file:

```
<span><span>// Fetch the last 5 invoices, sorted by date</span></span>
<span><span>const</span><span> </span><span>data</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>sql</span><span>&lt;</span><span>LatestInvoiceRaw</span><span>&gt;`</span></span>
<span><span>  SELECT invoices.amount, customers.name, customers.image_url, customers.email</span></span>
<span><span>  FROM invoices</span></span>
<span><span>  JOIN customers ON invoices.customer_id = customers.id</span></span>
<span><span>  ORDER BY invoices.date DESC</span></span>
<span><span>  LIMIT 5`</span><span>;</span></span>
```

In your page, import the `fetchLatestInvoices` function:

```
<span><span>import</span><span> { Card } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/cards'</span><span>;</span></span>
<span><span>import</span><span> RevenueChart </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/revenue-chart'</span><span>;</span></span>
<span><span>import</span><span> LatestInvoices </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/latest-invoices'</span><span>;</span></span>
<span><span>import</span><span> { lusitana } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/fonts'</span><span>;</span></span>
<span><span>import</span><span> { fetchRevenue</span><span>,</span><span> fetchLatestInvoices } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/data'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>revenue</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchRevenue</span><span>();</span></span>
<span><span>  </span><span>const</span><span> </span><span>latestInvoices</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchLatestInvoices</span><span>();</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

Then, uncomment the `<LatestInvoices />` component. You will also need to uncomment the relevant code in the `<LatestInvoices />` component itself, located at `/app/ui/dashboard/latest-invoices`.

If you visit your localhost, you should see that only the last 5 are returned from the database. Hopefully, you're beginning to see the advantages of querying your database directly!

![Latest invoices component alongside the revenue chart](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Flatest-invoices.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

## [Practice: Fetch data for the `<Card>` components](https://nextjs.org/learn/dashboard-app/fetching-data#practice-fetch-data-for-the-card-components)

Now it's your turn to fetch data for the `<Card>` components. The cards will display the following data:

-   Total amount of invoices collected.
-   Total amount of invoices pending.
-   Total number of invoices.
-   Total number of customers.

Again, you might be tempted to fetch all the invoices and customers, and use JavaScript to manipulate the data. For example, you could use `Array.length` to get the total number of invoices and customers:

```
<span><span>const</span><span> </span><span>totalInvoices</span><span> </span><span>=</span><span> </span><span>allInvoices</span><span>.</span><span>length</span><span>;</span></span>
<span><span>const</span><span> </span><span>totalCustomers</span><span> </span><span>=</span><span> </span><span>allCustomers</span><span>.</span><span>length</span><span>;</span></span>
```

But with SQL, you can fetch only the data you need. It's a little longer than using `Array.length`, but it means less data needs to be transferred during the request. This is the SQL alternative:

```
<span><span>const</span><span> </span><span>invoiceCountPromise</span><span> </span><span>=</span><span> </span><span>sql</span><span>`SELECT COUNT(*) FROM invoices`</span><span>;</span></span>
<span><span>const</span><span> </span><span>customerCountPromise</span><span> </span><span>=</span><span> </span><span>sql</span><span>`SELECT COUNT(*) FROM customers`</span><span>;</span></span>
```

The function you will need to import is called `fetchCardData`. You will need to destructure the values returned from the function.

> **Hint:**
> 
> -   Check the card components to see what data they need.
> -   Check the `data.ts` file to see what the function returns.

Once you're ready, expand the toggle below for the final code:

Great! You've now fetched all the data for the dashboard overview page. Your page should look like this:

![Dashboard page with all the data fetched](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fcomplete-dashboard.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

However... there are two things you need to be aware of:

1.  The data requests are unintentionally blocking each other, creating a **request waterfall**.
2.  By default, Next.js **prerenders** routes to improve performance, this is called **Static Rendering**. So if your data changes, it won't be reflected in your dashboard.

Let's discuss number 1 in this chapter, then look into detail at number 2 in the next chapter.

## [What are request waterfalls?](https://nextjs.org/learn/dashboard-app/fetching-data#what-are-request-waterfalls)

A "waterfall" refers to a sequence of network requests that depend on the completion of previous requests. In the case of data fetching, each request can only begin once the previous request has returned data.

![Diagram showing time with sequential data fetching and parallel data fetching](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fsequential-parallel-data-fetching.png&w=3840&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

For example, we need to wait for `fetchRevenue()` to execute before `fetchLatestInvoices()` can start running, and so on.

```
<span><span>const</span><span> </span><span>revenue</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchRevenue</span><span>();</span></span>
<span><span>const</span><span> </span><span>latestInvoices</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchLatestInvoices</span><span>(); </span><span>// wait for fetchRevenue() to finish</span></span>
<span><span>const</span><span> {</span></span>
<span><span>  </span><span>numberOfInvoices</span><span>,</span></span>
<span><span>  </span><span>numberOfCustomers</span><span>,</span></span>
<span><span>  </span><span>totalPaidInvoices</span><span>,</span></span>
<span><span>  </span><span>totalPendingInvoices</span><span>,</span></span>
<span><span>} </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchCardData</span><span>(); </span><span>// wait for fetchLatestInvoices() to finish</span></span>
```

This pattern is not necessarily bad. There may be cases where you want waterfalls because you want a condition to be satisfied before you make the next request. For example, you might want to fetch a user's ID and profile information first. Once you have the ID, you might then proceed to fetch their list of friends. In this case, each request is contingent on the data returned from the previous request.

However, this behavior can also be unintentional and impact performance.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

When might you want to use a waterfall pattern?

## [Parallel data fetching](https://nextjs.org/learn/dashboard-app/fetching-data#parallel-data-fetching)

A common way to avoid waterfalls is to initiate all data requests at the same time - in parallel.

In JavaScript, you can use the [`Promise.all()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all) or [`Promise.allSettled()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/allSettled) functions to initiate all promises at the same time. For example, in `data.ts`, we're using `Promise.all()` in the `fetchCardData()` function:

```
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>fetchCardData</span><span>() {</span></span>
<span><span>  </span><span>try</span><span> {</span></span>
<span><span>    </span><span>const</span><span> </span><span>invoiceCountPromise</span><span> </span><span>=</span><span> </span><span>sql</span><span>`SELECT COUNT(*) FROM invoices`</span><span>;</span></span>
<span><span>    </span><span>const</span><span> </span><span>customerCountPromise</span><span> </span><span>=</span><span> </span><span>sql</span><span>`SELECT COUNT(*) FROM customers`</span><span>;</span></span>
<span><span>    </span><span>const</span><span> </span><span>invoiceStatusPromise</span><span> </span><span>=</span><span> </span><span>sql</span><span>`SELECT</span></span>
<span><span>         SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) AS "paid",</span></span>
<span><span>         SUM(CASE WHEN status = 'pending' THEN amount ELSE 0 END) AS "pending"</span></span>
<span><span>         FROM invoices`</span><span>;</span></span>
<span> </span>
<span><span>    </span><span>const</span><span> </span><span>data</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>Promise</span><span>.all</span><span>([</span></span>
<span><span>      invoiceCountPromise</span><span>,</span></span>
<span><span>      customerCountPromise</span><span>,</span></span>
<span><span>      invoiceStatusPromise</span><span>,</span></span>
<span><span>    ]);</span></span>
<span><span>    </span><span>// ...</span></span>
<span><span>  }</span></span>
<span><span>}</span></span>
```

By using this pattern, you can:

-   Start executing all data fetches at the same time, which can lead to performance gains.
-   Use a native JavaScript pattern that can be applied to any library or framework.

However, there is one **disadvantage** of relying only on this JavaScript pattern: what happens if one data request is slower than all the others?