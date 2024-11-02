---
created: 2024-11-01T23:05:35 (UTC -07:00)
tags: []
source: https://nextjs.org/learn/dashboard-app/optimizing-fonts-images
author: 
---

# Learn Next.js: Optimizing Fonts and Images | Next.js

> ## Excerpt
> Optimize fonts and images with the Next.js built-in components.

---
In the previous chapter, you learned how to style your Next.js application. Let's continue working on your home page by adding a custom font and a hero image.

In this chapter...

Here are the topics we’ll cover

How to add custom fonts with `next/font`.

How to add images with `next/image`.

How fonts and images are optimized in Next.js.

## [Why optimize fonts?](https://nextjs.org/learn/dashboard-app/optimizing-fonts-images#why-optimize-fonts)

Fonts play a significant role in the design of a website, but using custom fonts in your project can affect performance if the font files need to be fetched and loaded.

[Cumulative Layout Shift](https://vercel.com/blog/how-core-web-vitals-affect-seo) is a metric used by Google to evaluate the performance and user experience of a website. With fonts, layout shift happens when the browser initially renders text in a fallback or system font and then swaps it out for a custom font once it has loaded. This swap can cause the text size, spacing, or layout to change, shifting elements around it.

![Mock UI showing initial load of a page, followed by a layout shift as the custom font loads.](Learn%20Next.js%20Optimizing%20Fonts%20and%20Images%20%20Next.js/image.png)

Next.js automatically optimizes fonts in the application when you use the `next/font` module. It downloads font files at build time and hosts them with your other static assets. This means when a user visits your application, there are no additional network requests for fonts which would impact performance.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

How does Next.js optimize fonts?

## [Adding a primary font](https://nextjs.org/learn/dashboard-app/optimizing-fonts-images#adding-a-primary-font)

Let's add a custom Google font to your application to see how this works!

In your `/app/ui` folder, create a new file called `fonts.ts`. You'll use this file to keep the fonts that will be used throughout your application.

Import the `Inter` font from the `next/font/google` module - this will be your primary font. Then, specify what [subset](https://fonts.google.com/knowledge/glossary/subsetting) you'd like to load. In this case, `'latin'`:

```
<span><span>import</span><span> { Inter } </span><span>from</span><span> </span><span>'next/font/google'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> </span><span>inter</span><span> </span><span>=</span><span> </span><span>Inter</span><span>({ subsets</span><span>:</span><span> [</span><span>'latin'</span><span>] });</span></span>
```

Finally, add the font to the `<body>` element in `/app/layout.tsx`:

```
<span><span>import</span><span> </span><span>'@/</span><span>app</span><span>/ui/global.css'</span><span>;</span></span>
<span><span>import</span><span> { inter } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/fonts'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>RootLayout</span><span>({</span></span>
<span><span>  children</span><span>,</span></span>
<span><span>}</span><span>:</span><span> {</span></span>
<span><span>  children</span><span>:</span><span> </span><span>React</span><span>.</span><span>ReactNode</span><span>;</span></span>
<span><span>}) {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>html</span><span> </span><span>lang</span><span>=</span><span>"en"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>body</span><span> </span><span>className</span><span>=</span><span>{</span><span>`</span><span>${</span><span>inter</span><span>.className</span><span>}</span><span> antialiased`</span><span>}&gt;{children}&lt;/</span><span>body</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>html</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

By adding `Inter` to the `<body>` element, the font will be applied throughout your application. Here, you're also adding the Tailwind [`antialiased`](https://tailwindcss.com/docs/font-smoothing) class which smooths out the font. It's not necessary to use this class, but it adds a nice touch.

Navigate to your browser, open dev tools and select the `body` element. You should see `Inter` and `Inter_Fallback` are now applied under styles.

## [Practice: Adding a secondary font](https://nextjs.org/learn/dashboard-app/optimizing-fonts-images#practice-adding-a-secondary-font)

You can also add fonts to specific elements of your application.

Now it's your turn! In your `fonts.ts` file, import a secondary font called `Lusitana` and pass it to the `<p>` element in your `/app/page.tsx` file. In addition to specifying a subset like you did before, you'll also need to specify the font **weight**.

Once you're ready, expand the code snippet below to see the solution.

> **Hints:**
> 
> -   If you're unsure what weight options to pass to a font, check the TypeScript errors in your code editor.
> -   Visit the [Google Fonts](https://fonts.google.com/) website and search for `Lusitana` to see what options are available.
> -   See the documentation for [adding multiple fonts](https://nextjs.org/docs/app/building-your-application/optimizing/fonts#using-multiple-fonts) and the [full list of options](https://nextjs.org/docs/app/api-reference/components/font#font-function-arguments).

Finally, the `<AcmeLogo />` component also uses Lusitana. It was commented out to prevent errors, you can now uncomment it:

```
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>main</span><span> </span><span>className</span><span>=</span><span>"flex min-h-screen flex-col p-6"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"flex h-20 shrink-0 items-end rounded-lg bg-blue-500 p-4 md:h-52"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>AcmeLogo</span><span> /&gt;</span></span>
<span><span>        {</span><span>/* ... */</span><span>}</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>main</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Great, you've added two custom fonts to your application! Next, let's add a hero image to the home page.

## [Why optimize images?](https://nextjs.org/learn/dashboard-app/optimizing-fonts-images#why-optimize-images)

Next.js can serve **static assets**, like images, under the top-level [`/public`](https://nextjs.org/docs/app/building-your-application/optimizing/static-assets) folder. Files inside `/public` can be referenced in your application.

With regular HTML, you would add an image as follows:

```
<span><span>&lt;</span><span>img</span></span>
<span><span>  </span><span>src</span><span>=</span><span>"/hero.png"</span></span>
<span><span>  </span><span>alt</span><span>=</span><span>"Screenshots of the dashboard project showing desktop version"</span></span>
<span><span>/&gt;</span></span>
```

However, this means you have to manually:

-   Ensure your image is responsive on different screen sizes.
-   Specify image sizes for different devices.
-   Prevent layout shift as the images load.
-   Lazy load images that are outside the user's viewport.

Image Optimization is a large topic in web development that could be considered a specialization in itself. Instead of manually implementing these optimizations, you can use the `next/image` component to automatically optimize your images.

## [The `<Image>` component](https://nextjs.org/learn/dashboard-app/optimizing-fonts-images#the-image-component)

The `<Image>` Component is an extension of the HTML `<img>` tag, and comes with automatic image optimization, such as:

-   Preventing layout shift automatically when images are loading.
-   Resizing images to avoid shipping large images to devices with a smaller viewport.
-   Lazy loading images by default (images load as they enter the viewport).
-   Serving images in modern formats, like [WebP](https://developer.mozilla.org/en-US/docs/Web/Media/Formats/Image_types#webp) and [AVIF](https://developer.mozilla.org/en-US/docs/Web/Media/Formats/Image_types#avif_image), when the browser supports it.

## [Adding the desktop hero image](https://nextjs.org/learn/dashboard-app/optimizing-fonts-images#adding-the-desktop-hero-image)

Let's use the `<Image>` component. If you look inside the `/public` folder, you'll see there are two images: `hero-desktop.png` and `hero-mobile.png`. These two images are completely different, and they'll be shown depending if the user's device is a desktop or mobile.

In your `/app/page.tsx` file, import the component from [`next/image`](https://nextjs.org/docs/api-reference/next/image). Then, add the image under the comment:

```
<span><span>import</span><span> AcmeLogo </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/acme-logo'</span><span>;</span></span>
<span><span>import</span><span> { ArrowRightIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span><span>import</span><span> { lusitana } </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/fonts'</span><span>;</span></span>
<span><span>import</span><span> Image </span><span>from</span><span> </span><span>'next/image'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>Page</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    </span><span>// ...</span></span>
<span><span>    &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"flex items-center justify-center p-6 md:w-3/5 md:px-28 md:py-12"</span><span>&gt;</span></span>
<span><span>      {</span><span>/* Add Hero Images Here */</span><span>}</span></span>
<span><span>      &lt;</span><span>Image</span></span>
<span><span>        </span><span>src</span><span>=</span><span>"/hero-desktop.png"</span></span>
<span><span>        </span><span>width</span><span>=</span><span>{</span><span>1000</span><span>}</span></span>
<span><span>        </span><span>height</span><span>=</span><span>{</span><span>760</span><span>}</span></span>
<span><span>        </span><span>className</span><span>=</span><span>"hidden md:block"</span></span>
<span><span>        </span><span>alt</span><span>=</span><span>"Screenshots of the dashboard project showing desktop version"</span></span>
<span><span>      /&gt;</span></span>
<span><span>    &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    </span><span>//...</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

Here, you're setting the `width` to `1000` and `height` to `760` pixels. It's good practice to set the `width` and `height` of your images to avoid layout shift, these should be an aspect ratio **identical** to the source image.

You'll also notice the class `hidden` to remove the image from the DOM on mobile screens, and `md:block` to show the image on desktop screens.

This is what your home page should look like now:

![Styled home page with a custom font and hero image](Learn%20Next.js%20Optimizing%20Fonts%20and%20Images%20%20Next.js/image.1.png)

## [Practice: Adding the mobile hero image](https://nextjs.org/learn/dashboard-app/optimizing-fonts-images#practice-adding-the-mobile-hero-image)

Now it's your turn! Under the image you've just added, add another `<Image>` component for `hero-mobile.png`.

-   The image should have a `width` of `560` and `height` of `620` pixels.
-   It should be shown on mobile screens, and hidden on desktop - you can use dev tools to check if the desktop and mobile images are swapped correctly.

Once you're ready, expand the code snippet below to see the solution.

Great! Your home page now has a custom font and hero images.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

True or False: Images without dimensions and web fonts are common causes of layout shift.

## [Recommended reading](https://nextjs.org/learn/dashboard-app/optimizing-fonts-images#recommended-reading)

There's a lot more to learn about these topics, including optimizing remote images and using local font files. If you'd like to dive deeper into fonts and images, see:

-   [Image Optimization Docs](https://nextjs.org/docs/app/building-your-application/optimizing/images)
-   [Font Optimization Docs](https://nextjs.org/docs/app/building-your-application/optimizing/fonts)
-   [Improving Web Performance with Images (MDN)](https://developer.mozilla.org/en-US/docs/Learn/Performance/Multimedia)
-   [Web Fonts (MDN)](https://developer.mozilla.org/en-US/docs/Learn/CSS/Styling_text/Web_fonts)
-   [How Core Web Vitals Affect SEO](https://vercel.com/blog/how-core-web-vitals-affect-seo)
