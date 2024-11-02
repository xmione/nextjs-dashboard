In the previous chapter, you created the dashboard layout and pages. Now, let's add some links to allow users to navigate between the dashboard routes.

In this chapter...

Here are the topics we’ll cover

How to use the `next/link` component.

How to show an active link with the `usePathname()` hook.

How navigation works in Next.js.

## [Why optimize navigation?](https://nextjs.org/learn/dashboard-app/navigating-between-pages#why-optimize-navigation)

To link between pages, you'd traditionally use the `<a>` HTML element. At the moment, the sidebar links use `<a>` elements, but notice what happens when you navigate between the home, invoices, and customers pages on your browser.

Did you see it?

There's a full page refresh on each page navigation!

## [The `<Link>` component](https://nextjs.org/learn/dashboard-app/navigating-between-pages#the-link-component)

In Next.js, you can use the `<Link />` Component to link between pages in your application. `<Link>` allows you to do [client-side navigation](https://nextjs.org/docs/app/building-your-application/routing/linking-and-navigating#how-routing-and-navigation-works) with JavaScript.

To use the `<Link />` component, open `/app/ui/dashboard/nav-links.tsx`, and import the `Link` component from [`next/link`](https://nextjs.org/docs/app/api-reference/components/link). Then, replace the `<a>` tag with `<Link>`:

```
<span><span>import</span><span> {</span></span>
<span><span>  UserGroupIcon</span><span>,</span></span>
<span><span>  HomeIcon</span><span>,</span></span>
<span><span>  DocumentDuplicateIcon</span><span>,</span></span>
<span><span>} </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>NavLinks</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;&gt;</span></span>
<span><span>      {</span><span>links</span><span>.map</span><span>((link) </span><span>=&gt;</span><span> {</span></span>
<span><span>        </span><span>const</span><span> </span><span>LinkIcon</span><span> </span><span>=</span><span> </span><span>link</span><span>.icon;</span></span>
<span><span>        </span><span>return</span><span> (</span></span>
<span><span>          &lt;</span><span>Link</span></span>
<span><span>            </span><span>key</span><span>=</span><span>{</span><span>link</span><span>.name}</span></span>
<span><span>            </span><span>href</span><span>=</span><span>{</span><span>link</span><span>.href}</span></span>
<span><span>            </span><span>className</span><span>=</span><span>"flex h-[48px] grow items-center justify-center gap-2 rounded-md bg-gray-50 p-3 text-sm font-medium hover:bg-sky-100 hover:text-blue-600 md:flex-none md:justify-start md:p-2 md:px-3"</span></span>
<span><span>          &gt;</span></span>
<span><span>            &lt;</span><span>LinkIcon</span><span> </span><span>className</span><span>=</span><span>"w-6"</span><span> /&gt;</span></span>
<span><span>            &lt;</span><span>p</span><span> </span><span>className</span><span>=</span><span>"hidden md:block"</span><span>&gt;{</span><span>link</span><span>.name}&lt;/</span><span>p</span><span>&gt;</span></span>
<span><span>          &lt;/</span><span>Link</span><span>&gt;</span></span>
<span><span>        );</span></span>
<span><span>      })}</span></span>
<span><span>    &lt;/&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

As you can see, the `Link` component is similar to using `<a>` tags, but instead of `<a href="…">`, you use `<Link href="…">`.

Save your changes and check to see if it works in your localhost. You should now be able to navigate between the pages without seeing a full refresh. Although parts of your application are rendered on the server, there's no full page refresh, making it feel like a web app. Why is that?

### [Automatic code-splitting and prefetching](https://nextjs.org/learn/dashboard-app/navigating-between-pages#automatic-code-splitting-and-prefetching)

To improve the navigation experience, Next.js automatically code splits your application by route segments. This is different from a traditional React [SPA](https://developer.mozilla.org/en-US/docs/Glossary/SPA), where the browser loads all your application code on initial load.

Splitting code by routes means that pages become isolated. If a certain page throws an error, the rest of the application will still work.

Furthermore, in production, whenever [`<Link>`](https://nextjs.org/docs/api-reference/next/link) components appear in the browser's viewport, Next.js automatically **prefetches** the code for the linked route in the background. By the time the user clicks the link, the code for the destination page will already be loaded in the background, and this is what makes the page transition near-instant!

Learn more about [how navigation works](https://nextjs.org/docs/app/building-your-application/routing/linking-and-navigating#how-routing-and-navigation-works).

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

What does Next.js do when a <Link> component appears in the browser’s viewport in a production environment?

## [Pattern: Showing active links](https://nextjs.org/learn/dashboard-app/navigating-between-pages#pattern-showing-active-links)

A common UI pattern is to show an active link to indicate to the user what page they are currently on. To do this, you need to get the user's current path from the URL. Next.js provides a hook called [`usePathname()`](https://nextjs.org/docs/app/api-reference/functions/use-pathname) that you can use to check the path and implement this pattern.

Since [`usePathname()`](https://nextjs.org/docs/app/api-reference/functions/use-pathname) is a hook, you'll need to turn `nav-links.tsx` into a Client Component. Add React's `"use client"` directive to the top of the file, then import `usePathname()` from `next/navigation`:

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> {</span></span>
<span><span>  UserGroupIcon</span><span>,</span></span>
<span><span>  HomeIcon</span><span>,</span></span>
<span><span>  InboxIcon</span><span>,</span></span>
<span><span>} </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span><span>import</span><span> { usePathname } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
```

Next, assign the path to a variable called `pathname` inside your `<NavLinks />` component:

```
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>NavLinks</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>pathname</span><span> </span><span>=</span><span> </span><span>usePathname</span><span>();</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

You can use the `clsx` library introduced in the chapter on [CSS styling](https://nextjs.org/learn/dashboard-app/css-styling) to conditionally apply class names when the link is active. When `link.href` matches the `pathname`, the link should be displayed with blue text and a light blue background.

Here's the final code for `nav-links.tsx`:

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> {</span></span>
<span><span>  UserGroupIcon</span><span>,</span></span>
<span><span>  HomeIcon</span><span>,</span></span>
<span><span>  DocumentDuplicateIcon</span><span>,</span></span>
<span><span>} </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span><span>import</span><span> { usePathname } </span><span>from</span><span> </span><span>'next/navigation'</span><span>;</span></span>
<span><span>import</span><span> clsx </span><span>from</span><span> </span><span>'clsx'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>NavLinks</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> </span><span>pathname</span><span> </span><span>=</span><span> </span><span>usePathname</span><span>();</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;&gt;</span></span>
<span><span>      {</span><span>links</span><span>.map</span><span>((link) </span><span>=&gt;</span><span> {</span></span>
<span><span>        </span><span>const</span><span> </span><span>LinkIcon</span><span> </span><span>=</span><span> </span><span>link</span><span>.icon;</span></span>
<span><span>        </span><span>return</span><span> (</span></span>
<span><span>          &lt;</span><span>Link</span></span>
<span><span>            </span><span>key</span><span>=</span><span>{</span><span>link</span><span>.name}</span></span>
<span><span>            </span><span>href</span><span>=</span><span>{</span><span>link</span><span>.href}</span></span>
<span><span>            </span><span>className</span><span>=</span><span>{</span><span>clsx</span><span>(</span></span>
<span><span>              </span><span>'flex h-[48px] grow items-center justify-center gap-2 rounded-md bg-gray-50 p-3 text-sm font-medium hover:bg-sky-100 hover:text-blue-600 md:flex-none md:justify-start md:p-2 md:px-3'</span><span>,</span></span>
<span><span>              {</span></span>
<span><span>                </span><span>'bg-sky-100 text-blue-600'</span><span>:</span><span> pathname </span><span>===</span><span> </span><span>link</span><span>.href</span><span>,</span></span>
<span><span>              }</span><span>,</span></span>
<span><span>            )}</span></span>
<span><span>          &gt;</span></span>
<span><span>            &lt;</span><span>LinkIcon</span><span> </span><span>className</span><span>=</span><span>"w-6"</span><span> /&gt;</span></span>
<span><span>            &lt;</span><span>p</span><span> </span><span>className</span><span>=</span><span>"hidden md:block"</span><span>&gt;{</span><span>link</span><span>.name}&lt;/</span><span>p</span><span>&gt;</span></span>
<span><span>          &lt;/</span><span>Link</span><span>&gt;</span></span>
<span><span>        );</span></span>
<span><span>      })}</span></span>
<span><span>    &lt;/&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Save and check your localhost. You should now see the active link highlighted in blue.