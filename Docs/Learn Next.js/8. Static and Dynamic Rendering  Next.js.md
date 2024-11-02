In the previous chapter, you fetched data for the Dashboard Overview page. However, we briefly discussed two limitations of the current setup:

1.  The data requests are creating an unintentional waterfall.
2.  The dashboard is static, so any data updates will not be reflected on your application.

In this chapter...

Here are the topics we’ll cover

What static rendering is and how it can improve your application's performance.

What dynamic rendering is and when to use it.

Different approaches to make your dashboard dynamic.

Simulate a slow data fetch to see what happens.

### [What is Static Rendering?](https://nextjs.org/learn/dashboard-app/static-and-dynamic-rendering#what-is-static-rendering)

With static rendering, data fetching and rendering happens on the server at build time (when you deploy) or when [revalidating data](https://nextjs.org/docs/app/building-your-application/data-fetching/fetching-caching-and-revalidating#revalidating-data).

Whenever a user visits your application, the cached result is served. There are a couple of benefits of static rendering:

-   **Faster Websites** - Prerendered content can be cached and globally distributed. This ensures that users around the world can access your website's content more quickly and reliably.
-   **Reduced Server Load** - Because the content is cached, your server does not have to dynamically generate content for each user request.
-   **SEO** - Prerendered content is easier for search engine crawlers to index, as the content is already available when the page loads. This can lead to improved search engine rankings.

Static rendering is useful for UI with **no data** or **data that is shared across users**, such as a static blog post or a product page. It might not be a good fit for a dashboard that has personalized data which is regularly updated.

The opposite of static rendering is dynamic rendering.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

Why might static rendering not be a good fit for a dashboard app?

## [What is Dynamic Rendering?](https://nextjs.org/learn/dashboard-app/static-and-dynamic-rendering#what-is-dynamic-rendering)

With dynamic rendering, content is rendered on the server for each user at **request time** (when the user visits the page). There are a couple of benefits of dynamic rendering:

-   **Real-Time Data** - Dynamic rendering allows your application to display real-time or frequently updated data. This is ideal for applications where data changes often.
-   **User-Specific Content** - It's easier to serve personalized content, such as dashboards or user profiles, and update the data based on user interaction.
-   **Request Time Information** - Dynamic rendering allows you to access information that can only be known at request time, such as cookies or the URL search parameters.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

What kind of information can only be known at request time?

## [Simulating a Slow Data Fetch](https://nextjs.org/learn/dashboard-app/static-and-dynamic-rendering#simulating-a-slow-data-fetch)

The dashboard application we're building is dynamic.

However, there is still one problem mentioned in the previous chapter. What happens if one data request is slower than all the others?

Let's simulate a slow data fetch. In your `data.ts` file, uncomment the `console.log` and `setTimeout` inside `fetchRevenue()`:

```
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>fetchRevenue</span><span>() {</span></span>
<span><span>  </span><span>try</span><span> {</span></span>
<span><span>    </span><span>// We artificially delay a response for demo purposes.</span></span>
<span><span>    </span><span>// Don't do this in production :)</span></span>
<span><span>    </span><span>console</span><span>.log</span><span>(</span><span>'Fetching revenue data...'</span><span>);</span></span>
<span><span>    </span><span>await</span><span> </span><span>new</span><span> </span><span>Promise</span><span>((resolve) </span><span>=&gt;</span><span> </span><span>setTimeout</span><span>(resolve</span><span>,</span><span> </span><span>3000</span><span>));</span></span>
<span> </span>
<span><span>    </span><span>const</span><span> </span><span>data</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>sql</span><span>&lt;</span><span>Revenue</span><span>&gt;`SELECT * FROM revenue`</span><span>;</span></span>
<span> </span>
<span><span>    </span><span>console</span><span>.log</span><span>(</span><span>'Data fetch completed after 3 seconds.'</span><span>);</span></span>
<span> </span>
<span><span>    </span><span>return</span><span> </span><span>data</span><span>.rows;</span></span>
<span><span>  } </span><span>catch</span><span> (error) {</span></span>
<span><span>    </span><span>console</span><span>.error</span><span>(</span><span>'Database Error:'</span><span>,</span><span> error);</span></span>
<span><span>    </span><span>throw</span><span> </span><span>new</span><span> </span><span>Error</span><span>(</span><span>'Failed to fetch revenue data.'</span><span>);</span></span>
<span><span>  }</span></span>
<span><span>}</span></span>
```

Now open [http://localhost:3000/dashboard/](http://localhost:3000/dashboard/) in a new tab and notice how the page takes longer to load. In your terminal, you should also see the following messages:

```
<span><span>Fetching revenue data</span><span>...</span></span>
<span><span>Data fetch completed after </span><span>3</span><span> seconds.</span></span>
```

Here, you've added an artificial 3-second delay to simulate a slow data fetch. The result is that now your whole page is blocked from showing UI to the visitor while the data is being fetched. Which brings us to a common challenge developers have to solve:

With dynamic rendering, **your application is only as fast as your slowest data fetch.**