Currently, your home page doesn't have any styles. Let's look at the different ways you can style your Next.js application.

In this chapter...

Here are the topics we’ll cover

How to add a global CSS file to your application.

Two different ways of styling: Tailwind and CSS modules.

How to conditionally add class names with the `clsx` utility package.

## [Global styles](https://nextjs.org/learn/dashboard-app/css-styling#global-styles)

If you look inside the `/app/ui` folder, you'll see a file called `global.css`. You can use this file to add CSS rules to **all** the routes in your application - such as CSS reset rules, site-wide styles for HTML elements like links, and more.

You can import `global.css` in any component in your application, but it's usually good practice to add it to your top-level component. In Next.js, this is the [root layout](https://nextjs.org/docs/app/building-your-application/routing/pages-and-layouts#root-layout-required) (more on this later).

Add global styles to your application by navigating to `/app/layout.tsx` and importing the `global.css` file:

```
<span><span>import</span><span> </span><span>'@/</span><span>app</span><span>/ui/global.css'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>RootLayout</span><span>({</span></span>
<span><span>  children</span><span>,</span></span>
<span><span>}</span><span>:</span><span> {</span></span>
<span><span>  children</span><span>:</span><span> </span><span>React</span><span>.</span><span>ReactNode</span><span>;</span></span>
<span><span>}) {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>html</span><span> </span><span>lang</span><span>=</span><span>"en"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>body</span><span>&gt;{children}&lt;/</span><span>body</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>html</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

With the development server still running, save your changes and preview them in the browser. Your home page should now look like this:

![Styled page with the logo 'Acme', a description, and login link.](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fhome-page-with-tailwind.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

But wait a second, you didn't add any CSS rules, where did the styles come from?

If you take a look inside `global.css`, you'll notice some `@tailwind` directives:

```
<span><span>@tailwind</span><span> base;</span></span>
<span><span>@tailwind</span><span> components;</span></span>
<span><span>@tailwind</span><span> utilities;</span></span>
```

## [Tailwind](https://nextjs.org/learn/dashboard-app/css-styling#tailwind)

[Tailwind](https://tailwindcss.com/) is a CSS framework that speeds up the development process by allowing you to quickly write [utility classes](https://tailwindcss.com/docs/utility-first) directly in your TSX markup.

In Tailwind, you style elements by adding class names. For example, adding the class `"text-blue-500"` will turn the `<h1>` text blue:

```
<span><span>&lt;</span><span>h1</span><span> </span><span>className</span><span>=</span><span>"text-blue-500"</span><span>&gt;I'm blue!&lt;/</span><span>h1</span><span>&gt;</span></span>
```

Although the CSS styles are shared globally, each class is singularly applied to each element. This means if you add or delete an element, you don't have to worry about maintaining separate stylesheets, style collisions, or the size of your CSS bundle growing as your application scales.

When you use `create-next-app` to start a new project, Next.js will ask if you want to use Tailwind. If you select `yes`, Next.js will automatically install the necessary packages and configure Tailwind in your application.

If you look at `/app/page.tsx`, you'll see that we're using Tailwind classes in the example.

```
<span><span>import</span><span> AcmeLogo </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/acme-logo'</span><span>;</span></span>
<span><span>import</span><span> { ArrowRightIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    </span><span>// These are Tailwind classes:</span></span>
<span><span>    &lt;</span><span>main</span><span> </span><span>className</span><span>=</span><span>"flex min-h-screen flex-col p-6"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"flex h-20 shrink-0 items-end rounded-lg bg-blue-500 p-4 md:h-52"</span><span>&gt;</span></span>
<span><span>    // ...</span></span>
<span><span>  )</span></span>
<span><span>}</span></span>
```

Don't worry if this is your first time using Tailwind. To save time, we've already styled all the components you'll be using.

Let's play with Tailwind! Copy the code below and paste it above the `<p>` element in `/app/page.tsx`:

```
<span><span>&lt;</span><span>div</span></span>
<span><span>  </span><span>className</span><span>=</span><span>"relative w-0 h-0 border-l-[15px] border-r-[15px] border-b-[26px] border-l-transparent border-r-transparent border-b-black"</span></span>
<span><span>/&gt;</span></span>
```

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

What shape do you see when using the code snippet above?

If you prefer writing traditional CSS rules or keeping your styles separate from your JSX - CSS Modules are a great alternative.

## [CSS Modules](https://nextjs.org/learn/dashboard-app/css-styling#css-modules)

[CSS Modules](https://nextjs.org/docs/basic-features/built-in-css-support) allow you to scope CSS to a component by automatically creating unique class names, so you don't have to worry about style collisions as well.

We'll continue using Tailwind in this course, but let's take a moment to see how you can achieve the same results from the quiz above using CSS modules.

Inside `/app/ui`, create a new file called `home.module.css` and add the following CSS rules:

```
<span><span>.shape</span><span> {</span></span>
<span><span>  </span><span>height</span><span>:</span><span> </span><span>0</span><span>;</span></span>
<span><span>  </span><span>width</span><span>:</span><span> </span><span>0</span><span>;</span></span>
<span><span>  </span><span>border-bottom</span><span>:</span><span> </span><span>30</span><span>px</span><span> solid black</span><span>;</span></span>
<span><span>  </span><span>border-left</span><span>:</span><span> </span><span>20</span><span>px</span><span> solid transparent</span><span>;</span></span>
<span><span>  </span><span>border-right</span><span>:</span><span> </span><span>20</span><span>px</span><span> solid transparent</span><span>;</span></span>
<span><span>}</span></span>
```

Then, inside your `/app/page.tsx` file import the styles and replace the Tailwind class names from the `<div>` you've added with `styles.shape`:

```
<span><span>import</span><span> AcmeLogo </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/acme-logo'</span><span>;</span></span>
<span><span>import</span><span> { ArrowRightIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span><span>import</span><span> styles </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/home.module.css'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>main</span><span> </span><span>className</span><span>=</span><span>"flex min-h-screen flex-col p-6"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>{</span><span>styles</span><span>.shape} /&gt;</span></span>
<span><span>    // ...</span></span>
<span><span>  )</span></span>
<span><span>}</span></span>
```

Save your changes and preview them in the browser. You should see the same shape as before.

Tailwind and CSS modules are the two most common ways of styling Next.js applications. Whether you use one or the other is a matter of preference - you can even use both in the same application!

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

What is one benefit of using CSS modules?

## [Using the `clsx` library to toggle class names](https://nextjs.org/learn/dashboard-app/css-styling#using-the-clsx-library-to-toggle-class-names)

There may be cases where you may need to conditionally style an element based on state or some other condition.

[`clsx`](https://www.npmjs.com/package/clsx) is a library that lets you toggle class names easily. We recommend taking a look at [documentation](https://github.com/lukeed/clsx) for more details, but here's the basic usage:

-   Suppose that you want to create an `InvoiceStatus` component which accepts `status`. The status can be `'pending'` or `'paid'`.
-   If it's `'paid'`, you want the color to be green. If it's `'pending'`, you want the color to be gray.

You can use `clsx` to conditionally apply the classes, like this:

```
<span><span>import</span><span> clsx </span><span>from</span><span> </span><span>'clsx'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>InvoiceStatus</span><span>({ status }</span><span>:</span><span> { status</span><span>:</span><span> </span><span>string</span><span> }) {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>span</span></span>
<span><span>      </span><span>className</span><span>=</span><span>{</span><span>clsx</span><span>(</span></span>
<span><span>        </span><span>'inline-flex items-center rounded-full px-2 py-1 text-sm'</span><span>,</span></span>
<span><span>        {</span></span>
<span><span>          </span><span>'bg-gray-100 text-gray-500'</span><span>:</span><span> status </span><span>===</span><span> </span><span>'pending'</span><span>,</span></span>
<span><span>          </span><span>'bg-green-500 text-white'</span><span>:</span><span> status </span><span>===</span><span> </span><span>'paid'</span><span>,</span></span>
<span><span>        }</span><span>,</span></span>
<span><span>      )}</span></span>
<span><span>    &gt;</span></span>
<span><span>    // ...</span></span>
<span><span>)}</span></span>
```

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

Search for "clsx" in your code editor, what components use it to conditionally apply class names?

## [Other styling solutions](https://nextjs.org/learn/dashboard-app/css-styling#other-styling-solutions)

In addition to the approaches we've discussed, you can also style your Next.js application with:

-   Sass which allows you to import `.css` and `.scss` files.
-   CSS-in-JS libraries such as [styled-jsx](https://github.com/vercel/styled-jsx), [styled-components](https://github.com/vercel/next.js/tree/canary/examples/with-styled-components), and [emotion](https://github.com/vercel/next.js/tree/canary/examples/with-emotion).

Take a look at the [CSS documentation](https://nextjs.org/docs/app/building-your-application/styling) for more information.