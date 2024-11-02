Metadata is crucial for SEO and shareability. In this chapter, we'll discuss how you can add metadata to your Next.js application.

In this chapter...

Here are the topics we’ll cover

How to add an Open Graph image using metadata.

How to add a favicon using metadata.

In web development, metadata provides additional details about a webpage. Metadata is not visible to the users visiting the page. Instead, it works behind the scenes, embedded within the page's HTML, usually within the `<head>` element. This hidden information is crucial for search engines and other systems that need to understand your webpage's content better.

Metadata plays a significant role in enhancing a webpage's SEO, making it more accessible and understandable for search engines and social media platforms. Proper metadata helps search engines effectively index webpages, improving their ranking in search results. Additionally, metadata like Open Graph improves the appearance of shared links on social media, making the content more appealing and informative for users.

There are various types of metadata, each serving a unique purpose. Some common types include:

**Title Metadata**: Responsible for the title of a webpage that is displayed on the browser tab. It's crucial for SEO as it helps search engines understand what the webpage is about.

```
<span><span>&lt;</span><span>title</span><span>&gt;Page Title&lt;/</span><span>title</span><span>&gt;</span></span>
```

**Description Metadata**: This metadata provides a brief overview of the webpage content and is often displayed in search engine results.

```
<span><span>&lt;</span><span>meta</span><span> </span><span>name</span><span>=</span><span>"description"</span><span> </span><span>content</span><span>=</span><span>"A brief description of the page content."</span><span> /&gt;</span></span>
```

**Keyword Metadata**: This metadata includes the keywords related to the webpage content, helping search engines index the page.

```
<span><span>&lt;</span><span>meta</span><span> </span><span>name</span><span>=</span><span>"keywords"</span><span> </span><span>content</span><span>=</span><span>"keyword1, keyword2, keyword3"</span><span> /&gt;</span></span>
```

**Open Graph Metadata**: This metadata enhances the way a webpage is represented when shared on social media platforms, providing information such as the title, description, and preview image.

```
<span><span>&lt;</span><span>meta</span><span> </span><span>property</span><span>=</span><span>"og:title"</span><span> </span><span>content</span><span>=</span><span>"Title Here"</span><span> /&gt;</span></span>
<span><span>&lt;</span><span>meta</span><span> </span><span>property</span><span>=</span><span>"og:description"</span><span> </span><span>content</span><span>=</span><span>"Description Here"</span><span> /&gt;</span></span>
<span><span>&lt;</span><span>meta</span><span> </span><span>property</span><span>=</span><span>"og:image"</span><span> </span><span>content</span><span>=</span><span>"image_url_here"</span><span> /&gt;</span></span>
```

**Favicon Metadata**: This metadata links the favicon (a small icon) to the webpage, displayed in the browser's address bar or tab.

```
<span><span>&lt;</span><span>link</span><span> </span><span>rel</span><span>=</span><span>"icon"</span><span> </span><span>href</span><span>=</span><span>"path/to/favicon.ico"</span><span> /&gt;</span></span>
```

Next.js has a Metadata API that can be used to define your application metadata. There are two ways you can add metadata to your application:

-   **Config-based**: Export a [static `metadata` object](https://nextjs.org/docs/app/api-reference/functions/generate-metadata#metadata-object) or a dynamic [`generateMetadata` function](https://nextjs.org/docs/app/api-reference/functions/generate-metadata#generatemetadata-function) in a `layout.js` or `page.js` file.
    
-   **File-based**: Next.js has a range of special files that are specifically used for metadata purposes:
    
    -   `favicon.ico`, `apple-icon.jpg`, and `icon.jpg`: Utilized for favicons and icons
    -   `opengraph-image.jpg` and `twitter-image.jpg`: Employed for social media images
    -   `robots.txt`: Provides instructions for search engine crawling
    -   `sitemap.xml`: Offers information about the website's structure

You have the flexibility to use these files for static metadata, or you can generate them programmatically within your project.

With both these options, Next.js will automatically generate the relevant `<head>` elements for your pages.

### [Favicon and Open Graph image](https://nextjs.org/learn/dashboard-app/adding-metadata#favicon-and-open-graph-image)

In your `/public` folder, you'll notice you have two images: `favicon.ico` and `opengraph-image.jpg`.

Move these images to the root of your `/app` folder.

After doing this, Next.js will automatically identify and use these files as your favicon and OG image. You can verify this by checking the `<head>` element of your application in dev tools.

> **Good to know:** You can also create dynamic OG images using the [`ImageResponse`](https://nextjs.org/docs/app/api-reference/functions/image-response) constructor.

### [Page title and descriptions](https://nextjs.org/learn/dashboard-app/adding-metadata#page-title-and-descriptions)

You can also include a [`metadata` object](https://nextjs.org/docs/app/api-reference/functions/generate-metadata#metadata-fields) from any `layout.js` or `page.js` file to add additional page information like title and description. Any metadata in `layout.js` will be inherited by all pages that use it.

In your root layout, create a new `metadata` object with the following fields:

```
<span><span>import</span><span> { Metadata } </span><span>from</span><span> </span><span>'next'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> </span><span>metadata</span><span>:</span><span> </span><span>Metadata</span><span> </span><span>=</span><span> {</span></span>
<span><span>  title</span><span>:</span><span> </span><span>'Acme Dashboard'</span><span>,</span></span>
<span><span>  description</span><span>:</span><span> </span><span>'The official Next.js Course Dashboard, built with App Router.'</span><span>,</span></span>
<span><span>  metadataBase</span><span>:</span><span> </span><span>new</span><span> </span><span>URL</span><span>(</span><span>'https://next-learn-dashboard.vercel.sh'</span><span>)</span><span>,</span></span>
<span><span>};</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>RootLayout</span><span>() {</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>}</span></span>
```

Next.js will automatically add the title and metadata to your application.

But what if you want to add a custom title for a specific page? You can do this by adding a `metadata` object to the page itself. Metadata in nested pages will override the metadata in the parent.

For example, in the `/dashboard/invoices` page, you can update the page title:

```
<span><span>import</span><span> { Metadata } </span><span>from</span><span> </span><span>'next'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> </span><span>metadata</span><span>:</span><span> </span><span>Metadata</span><span> </span><span>=</span><span> {</span></span>
<span><span>  title</span><span>:</span><span> </span><span>'Invoices | Acme Dashboard'</span><span>,</span></span>
<span><span>};</span></span>
```

This works, but we are repeating the title of the application in every page. If something changes, like the company name, you'd have to update it on every page.

Instead, you can use the `title.template` field in the `metadata` object to define a template for your page titles. This template can include the page title, and any other information you want to include.

In your root layout, update the `metadata` object to include a template:

```
<span><span>import</span><span> { Metadata } </span><span>from</span><span> </span><span>'next'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> </span><span>metadata</span><span>:</span><span> </span><span>Metadata</span><span> </span><span>=</span><span> {</span></span>
<span><span>  title</span><span>:</span><span> {</span></span>
<span><span>    template</span><span>:</span><span> </span><span>'%s | Acme Dashboard'</span><span>,</span></span>
<span><span>    default</span><span>:</span><span> </span><span>'Acme Dashboard'</span><span>,</span></span>
<span><span>  }</span><span>,</span></span>
<span><span>  description</span><span>:</span><span> </span><span>'The official Next.js Learn Dashboard built with App Router.'</span><span>,</span></span>
<span><span>  metadataBase</span><span>:</span><span> </span><span>new</span><span> </span><span>URL</span><span>(</span><span>'https://next-learn-dashboard.vercel.sh'</span><span>)</span><span>,</span></span>
<span><span>};</span></span>
```

The `%s` in the template will be replaced with the specific page title.

Now, in your `/dashboard/invoices` page, you can add the page title:

```
<span><span>export</span><span> </span><span>const</span><span> </span><span>metadata</span><span>:</span><span> </span><span>Metadata</span><span> </span><span>=</span><span> {</span></span>
<span><span>  title</span><span>:</span><span> </span><span>'Invoices'</span><span>,</span></span>
<span><span>};</span></span>
```

Navigate to the `/dashboard/invoices` page and check the `<head>` element. You should see the page title is now `Invoices | Acme Dashboard`.

Now that you've learned about metadata, practice by adding titles to your other pages:

1.  `/login` page.
2.  `/dashboard/` page.
3.  `/dashboard/customers` page.
4.  `/dashboard/invoices/create` page.
5.  `/dashboard/invoices/[id]/edit` page.

The Next.js Metadata API is powerful and flexible, giving you full control over your application's metadata. Here, we've shown you how to add some basic metadata, but you can add multiple fields, including `keywords`, `robots`, `canonical`, and more. Feel free to explore the [documentation](https://nextjs.org/docs/app/api-reference/functions/generate-metadata), and add any additional metadata you want to your application.