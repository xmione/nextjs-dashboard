In the previous chapter, you learned about the different rendering methods of Next.js. We also discussed how slow data fetches can impact the performance of your application. Let's look at how you can improve the user experience when there are slow data requests.

In this chapter...

Here are the topics we’ll cover

What streaming is and when you might use it.

How to implement streaming with `loading.tsx` and Suspense.

What loading skeletons are.

What route groups are, and when you might use them.

Where to place Suspense boundaries in your application.

## [What is streaming?](https://nextjs.org/learn/dashboard-app/streaming#what-is-streaming)

Streaming is a data transfer technique that allows you to break down a route into smaller "chunks" and progressively stream them from the server to the client as they become ready.

![Diagram showing time with sequential data fetching and parallel data fetching](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fserver-rendering-with-streaming.png&w=3840&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

By streaming, you can prevent slow data requests from blocking your whole page. This allows the user to see and interact with parts of the page without waiting for all the data to load before any UI can be shown to the user.

![Diagram showing time with sequential data fetching and parallel data fetching](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fserver-rendering-with-streaming-chart.png&w=3840&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

Streaming works well with React's component model, as each component can be considered a _chunk_.

There are two ways you implement streaming in Next.js:

1.  At the page level, with the `loading.tsx` file.
2.  For specific components, with `<Suspense>`.

Let's see how this works.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

What is one advantage of streaming?

## [Streaming a whole page with `loading.tsx`](https://nextjs.org/learn/dashboard-app/streaming#streaming-a-whole-page-with-loadingtsx)

In the `/app/dashboard` folder, create a new file called `loading.tsx`:

```
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Loading</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> &lt;</span><span>div</span><span>&gt;Loading...&lt;/</span><span>div</span><span>&gt;;</span></span>
<span><span>}</span></span>
```

Refresh [http://localhost:3000/dashboard](http://localhost:3000/dashboard), and you should now see:

![Dashboard page with 'Loading...' text](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Floading-page.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

A few things are happening here:

1.  `loading.tsx` is a special Next.js file built on top of Suspense, it allows you to create fallback UI to show as a replacement while page content loads.
2.  Since `<SideNav>` is static, it's shown immediately. The user can interact with `<SideNav>` while the dynamic content is loading.
3.  The user doesn't have to wait for the page to finish loading before navigating away (this is called interruptable navigation).

Congratulations! You've just implemented streaming. But we can do more to improve the user experience. Let's show a loading skeleton instead of the `Loading…` text.

### [Adding loading skeletons](https://nextjs.org/learn/dashboard-app/streaming#adding-loading-skeletons)

A loading skeleton is a simplified version of the UI. Many websites use them as a placeholder (or fallback) to indicate to users that the content is loading. Any UI you add in `loading.tsx` will be embedded as part of the static file, and sent first. Then, the rest of the dynamic content will be streamed from the server to the client.

Inside your `loading.tsx` file, import a new component called `<DashboardSkeleton>`:

```
<span><span>import</span><span> DashboardSkeleton </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/skeletons'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Loading</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> &lt;</span><span>DashboardSkeleton</span><span> /&gt;;</span></span>
<span><span>}</span></span>
```

Then, refresh [http://localhost:3000/dashboard](http://localhost:3000/dashboard), and you should now see:

![Dashboard page with loading skeletons](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Floading-page-with-skeleton.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

### [Fixing the loading skeleton bug with route groups](https://nextjs.org/learn/dashboard-app/streaming#fixing-the-loading-skeleton-bug-with-route-groups)

Right now, your loading skeleton will apply to the invoices and customers pages as well.

Since `loading.tsx` is a level higher than `/invoices/page.tsx` and `/customers/page.tsx` in the file system, it's also applied to those pages.

We can change this with [Route Groups](https://nextjs.org/docs/app/building-your-application/routing/route-groups). Create a new folder called `/(overview)` inside the dashboard folder. Then, move your `loading.tsx` and `page.tsx` files inside the folder:

![Folder structure showing how to create a route group using parentheses](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Froute-group.png&w=3840&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

Now, the `loading.tsx` file will only apply to your dashboard overview page.

Route groups allow you to organize files into logical groups without affecting the URL path structure. When you create a new folder using parentheses `()`, the name won't be included in the URL path. So `/dashboard/(overview)/page.tsx` becomes `/dashboard`.

Here, you're using a route group to ensure `loading.tsx` only applies to your dashboard overview page. However, you can also use route groups to separate your application into sections (e.g. `(marketing)` routes and `(shop)` routes) or by teams for larger applications.

### [Streaming a component](https://nextjs.org/learn/dashboard-app/streaming#streaming-a-component)

So far, you're streaming a whole page. But you can also be more granular and stream specific components using React Suspense.

Suspense allows you to defer rendering parts of your application until some condition is met (e.g. data is loaded). You can wrap your dynamic components in Suspense. Then, pass it a fallback component to show while the dynamic component loads.

If you remember the slow data request, `fetchRevenue()`, this is the request that is slowing down the whole page. Instead of blocking your whole page, you can use Suspense to stream only this component and immediately show the rest of the page's UI.

To do so, you'll need to move the data fetch to the component, let's update the code to see what that'll look like:

Delete all instances of `fetchRevenue()` and its data from `/dashboard/(overview)/page.tsx`:

```
<span><span>import</span><span> { Card } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/cards'</span><span>;</span></span>
<span><span>import</span><span> RevenueChart </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/revenue-chart'</span><span>;</span></span>
<span><span>import</span><span> LatestInvoices </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/latest-invoices'</span><span>;</span></span>
<span><span>import</span><span> { lusitana } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/fonts'</span><span>;</span></span>
<span><span>import</span><span> { fetchLatestInvoices</span><span>,</span><span> fetchCardData } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/data'</span><span>; </span><span>// remove fetchRevenue</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>revenue</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchRevenue</span><span>() </span><span>// delete this line</span></span>
<span><span>  </span><span>const</span><span> </span><span>latestInvoices</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchLatestInvoices</span><span>();</span></span>
<span><span>  </span><span>const</span><span> {</span></span>
<span><span>    </span><span>numberOfInvoices</span><span>,</span></span>
<span><span>    </span><span>numberOfCustomers</span><span>,</span></span>
<span><span>    </span><span>totalPaidInvoices</span><span>,</span></span>
<span><span>    </span><span>totalPendingInvoices</span><span>,</span></span>
<span><span>  } </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchCardData</span><span>();</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    </span><span>// ...</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Then, import `<Suspense>` from React, and wrap it around `<RevenueChart />`. You can pass it a fallback component called `<RevenueChartSkeleton>`.

```
<span><span>import</span><span> { Card } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/cards'</span><span>;</span></span>
<span><span>import</span><span> RevenueChart </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/revenue-chart'</span><span>;</span></span>
<span><span>import</span><span> LatestInvoices </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/latest-invoices'</span><span>;</span></span>
<span><span>import</span><span> { lusitana } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/fonts'</span><span>;</span></span>
<span><span>import</span><span> { fetchLatestInvoices</span><span>,</span><span> fetchCardData } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/data'</span><span>;</span></span>
<span><span>import</span><span> { Suspense } </span><span>from</span><span> </span><span>'react'</span><span>;</span></span>
<span><span>import</span><span> { RevenueChartSkeleton } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/skeletons'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>latestInvoices</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchLatestInvoices</span><span>();</span></span>
<span><span>  </span><span>const</span><span> {</span></span>
<span><span>    </span><span>numberOfInvoices</span><span>,</span></span>
<span><span>    </span><span>numberOfCustomers</span><span>,</span></span>
<span><span>    </span><span>totalPaidInvoices</span><span>,</span></span>
<span><span>    </span><span>totalPendingInvoices</span><span>,</span></span>
<span><span>  } </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchCardData</span><span>();</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>main</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>h1</span><span> </span><span>className</span><span>=</span><span>{</span><span>`</span><span>${</span><span>lusitana</span><span>.className</span><span>}</span><span> mb-4 text-xl md:text-2xl`</span><span>}&gt;</span></span>
<span><span>        Dashboard</span></span>
<span><span>      &lt;/</span><span>h1</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"grid gap-6 sm:grid-cols-2 lg:grid-cols-4"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>Card</span><span> </span><span>title</span><span>=</span><span>"Collected"</span><span> </span><span>value</span><span>=</span><span>{totalPaidInvoices} </span><span>type</span><span>=</span><span>"collected"</span><span> /&gt;</span></span>
<span><span>        &lt;</span><span>Card</span><span> </span><span>title</span><span>=</span><span>"Pending"</span><span> </span><span>value</span><span>=</span><span>{totalPendingInvoices} </span><span>type</span><span>=</span><span>"pending"</span><span> /&gt;</span></span>
<span><span>        &lt;</span><span>Card</span><span> </span><span>title</span><span>=</span><span>"Total Invoices"</span><span> </span><span>value</span><span>=</span><span>{numberOfInvoices} </span><span>type</span><span>=</span><span>"invoices"</span><span> /&gt;</span></span>
<span><span>        &lt;</span><span>Card</span></span>
<span><span>          </span><span>title</span><span>=</span><span>"Total Customers"</span></span>
<span><span>          </span><span>value</span><span>=</span><span>{numberOfCustomers}</span></span>
<span><span>          </span><span>type</span><span>=</span><span>"customers"</span></span>
<span><span>        /&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"mt-6 grid grid-cols-1 gap-6 md:grid-cols-4 lg:grid-cols-8"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>Suspense</span><span> </span><span>fallback</span><span>=</span><span>{&lt;</span><span>RevenueChartSkeleton</span><span> /&gt;}&gt;</span></span>
<span><span>          &lt;</span><span>RevenueChart</span><span> /&gt;</span></span>
<span><span>        &lt;/</span><span>Suspense</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>LatestInvoices</span><span> </span><span>latestInvoices</span><span>=</span><span>{latestInvoices} /&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>main</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Finally, update the `<RevenueChart>` component to fetch its own data and remove the prop passed to it:

```
<span><span>import</span><span> { generateYAxis } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/utils'</span><span>;</span></span>
<span><span>import</span><span> { CalendarIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> { lusitana } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/fonts'</span><span>;</span></span>
<span><span>import</span><span> { fetchRevenue } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/data'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>RevenueChart</span><span>() { </span><span>// Make component async, remove the props</span></span>
<span><span>  </span><span>const</span><span> </span><span>revenue</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchRevenue</span><span>(); </span><span>// Fetch data inside the component</span></span>
<span> </span>
<span><span>  </span><span>const</span><span> </span><span>chartHeight</span><span> </span><span>=</span><span> </span><span>350</span><span>;</span></span>
<span><span>  </span><span>const</span><span> { </span><span>yAxisLabels</span><span>,</span><span> </span><span>topLabel</span><span> } </span><span>=</span><span> </span><span>generateYAxis</span><span>(revenue);</span></span>
<span> </span>
<span><span>  </span><span>if</span><span> (</span><span>!</span><span>revenue </span><span>||</span><span> </span><span>revenue</span><span>.</span><span>length</span><span> </span><span>===</span><span> </span><span>0</span><span>) {</span></span>
<span><span>    </span><span>return</span><span> &lt;</span><span>p</span><span> </span><span>className</span><span>=</span><span>"mt-4 text-gray-400"</span><span>&gt;No data available.&lt;/</span><span>p</span><span>&gt;;</span></span>
<span><span>  }</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    </span><span>// ...</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
<span> </span>
```

Now refresh the page, you should see the dashboard information almost immediately, while a fallback skeleton is shown for `<RevenueChart>`:

![Dashboard page with revenue chart skeleton and loaded Card and Latest Invoices components](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Floading-revenue-chart.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

### [Practice: Streaming `<LatestInvoices>`](https://nextjs.org/learn/dashboard-app/streaming#practice-streaming-latestinvoices)

Now it's your turn! Practice what you've just learned by streaming the `<LatestInvoices>` component.

Move `fetchLatestInvoices()` down from the page to the `<LatestInvoices>` component. Wrap the component in a `<Suspense>` boundary with a fallback called `<LatestInvoicesSkeleton>`.

Once you're ready, expand the toggle to see the solution code:

## [Grouping components](https://nextjs.org/learn/dashboard-app/streaming#grouping-components)

Great! You're almost there, now you need to wrap the `<Card>` components in Suspense. You can fetch data for each individual card, but this could lead to a _popping_ effect as the cards load in, this can be visually jarring for the user.

So, how would you tackle this problem?

To create more of a _staggered_ effect, you can group the cards using a wrapper component. This means the static `<SideNav/>` will be shown first, followed by the cards, etc.

In your `page.tsx` file:

1.  Delete your `<Card>` components.
2.  Delete the `fetchCardData()` function.
3.  Import a new **wrapper** component called `<CardWrapper />`.
4.  Import a new **skeleton** component called `<CardsSkeleton />`.
5.  Wrap `<CardWrapper />` in Suspense.

```
<span><span>import</span><span> CardWr</span><span>app</span><span>er </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/dashboard/cards'</span><span>;</span></span>
<span><span>// ...</span></span>
<span><span>import</span><span> {</span></span>
<span><span>  RevenueChartSkeleton</span><span>,</span></span>
<span><span>  LatestInvoicesSkeleton</span><span>,</span></span>
<span><span>  CardsSkeleton</span><span>,</span></span>
<span><span>} </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/skeletons'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>main</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>h1</span><span> </span><span>className</span><span>=</span><span>{</span><span>`</span><span>${</span><span>lusitana</span><span>.className</span><span>}</span><span> mb-4 text-xl md:text-2xl`</span><span>}&gt;</span></span>
<span><span>        Dashboard</span></span>
<span><span>      &lt;/</span><span>h1</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"grid gap-6 sm:grid-cols-2 lg:grid-cols-4"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>Suspense</span><span> </span><span>fallback</span><span>=</span><span>{&lt;</span><span>CardsSkeleton</span><span> /&gt;}&gt;</span></span>
<span><span>          &lt;</span><span>CardWr</span><span>app</span><span>er</span><span> /&gt;</span></span>
<span><span>        &lt;/</span><span>Suspense</span><span>&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      // ...</span></span>
<span><span>    &lt;/</span><span>main</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Then, move into the file `/app/ui/dashboard/cards.tsx`, import the `fetchCardData()` function, and invoke it inside the `<CardWrapper/>` component. Make sure to uncomment any necessary code in this component.

```
<span><span>// ...</span></span>
<span><span>import</span><span> { fetchCardData } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/lib/data'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>CardWr</span><span>app</span><span>er</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> {</span></span>
<span><span>    </span><span>numberOfInvoices</span><span>,</span></span>
<span><span>    </span><span>numberOfCustomers</span><span>,</span></span>
<span><span>    </span><span>totalPaidInvoices</span><span>,</span></span>
<span><span>    </span><span>totalPendingInvoices</span><span>,</span></span>
<span><span>  } </span><span>=</span><span> </span><span>await</span><span> </span><span>fetchCardData</span><span>();</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;&gt;</span></span>
<span><span>      &lt;</span><span>Card</span><span> </span><span>title</span><span>=</span><span>"Collected"</span><span> </span><span>value</span><span>=</span><span>{totalPaidInvoices} </span><span>type</span><span>=</span><span>"collected"</span><span> /&gt;</span></span>
<span><span>      &lt;</span><span>Card</span><span> </span><span>title</span><span>=</span><span>"Pending"</span><span> </span><span>value</span><span>=</span><span>{totalPendingInvoices} </span><span>type</span><span>=</span><span>"pending"</span><span> /&gt;</span></span>
<span><span>      &lt;</span><span>Card</span><span> </span><span>title</span><span>=</span><span>"Total Invoices"</span><span> </span><span>value</span><span>=</span><span>{numberOfInvoices} </span><span>type</span><span>=</span><span>"invoices"</span><span> /&gt;</span></span>
<span><span>      &lt;</span><span>Card</span></span>
<span><span>        </span><span>title</span><span>=</span><span>"Total Customers"</span></span>
<span><span>        </span><span>value</span><span>=</span><span>{numberOfCustomers}</span></span>
<span><span>        </span><span>type</span><span>=</span><span>"customers"</span></span>
<span><span>      /&gt;</span></span>
<span><span>    &lt;/&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Refresh the page, and you should see all the cards load in at the same time. You can use this pattern when you want multiple components to load in at the same time.

## [Deciding where to place your Suspense boundaries](https://nextjs.org/learn/dashboard-app/streaming#deciding-where-to-place-your-suspense-boundaries)

Where you place your Suspense boundaries will depend on a few things:

1.  How you want the user to experience the page as it streams.
2.  What content you want to prioritize.
3.  If the components rely on data fetching.

Take a look at your dashboard page, is there anything you would've done differently?

Don't worry. There isn't a right answer.

-   You could stream the **whole page** like we did with `loading.tsx`... but that may lead to a longer loading time if one of the components has a slow data fetch.
-   You could stream **every component** individually... but that may lead to UI _popping_ into the screen as it becomes ready.
-   You could also create a _staggered_ effect by streaming **page sections**. But you'll need to create wrapper components.

Where you place your suspense boundaries will vary depending on your application. In general, it's good practice to move your data fetches down to the components that need it, and then wrap those components in Suspense. But there is nothing wrong with streaming the sections or the whole page if that's what your application needs.

Don't be afraid to experiment with Suspense and see what works best, it's a powerful API that can help you create more delightful user experiences.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

In general, what is considered good practice when working with Suspense and data fetching?

## [Looking ahead](https://nextjs.org/learn/dashboard-app/streaming#looking-ahead)

Streaming and Server Components give us new ways to handle data fetching and loading states, ultimately with the goal of improving the end user experience.

In the next chapter, you'll learn about Partial Prerendering, a new Next.js rendering model built with streaming in mind.