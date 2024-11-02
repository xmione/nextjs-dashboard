## [Creating a new project](https://nextjs.org/learn/dashboard-app/getting-started#creating-a-new-project)

We recommend using [`pnpm`](https://pnpm.io/) as your package manager, as it's faster and more efficient than `npm` or `yarn`. If you don't have `pnpm` installed, you can install it globally by running:

To create a Next.js app, open your terminal, [`cd`](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Understanding_client-side_tools/Command_line#basic_built-in_terminal_commands) into the folder you'd like to keep your project, and run the following command:

```
<span><span>npx </span><span>create-next-app@latest</span><span> </span><span>nextjs-dashboard</span><span> </span><span>--example</span><span> </span><span>"https://github.com/vercel/next-learn/tree/main/dashboard/starter-example"</span><span> </span><span>--use-pnpm</span></span>
```

This command uses [`create-next-app`](https://nextjs.org/docs/app/api-reference/create-next-app), a Command Line Interface (CLI) tool that sets up a Next.js application for you. In the command above, you're also using the `--example` flag with the [starter example](https://github.com/vercel/next-learn/tree/main/dashboard/starter-example) for this course.

## [Exploring the project](https://nextjs.org/learn/dashboard-app/getting-started#exploring-the-project)

Unlike tutorials that have you write code from scratch, much of the code for this course is already written for you. This better reflects real-world development, where you'll likely be working with existing codebases.

Our goal is to help you focus on learning the main features of Next.js, without having to write _all_ the application code.

After installation, open the project in your code editor and navigate to `nextjs-dashboard`.

Let's spend some time exploring the project.

### [Folder structure](https://nextjs.org/learn/dashboard-app/getting-started#folder-structure)

You'll notice that the project has the following folder structure:

![Folder structure of the dashboard project, showing the main folders and files: app, public, and config files.](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Flearn-folder-structure.png&w=3840&q=75&dpl=dpl_5DU7MtoYzzYKJbui3G5kbf54JXGA)

-   **`/app`**: Contains all the routes, components, and logic for your application, this is where you'll be mostly working from.
-   **`/app/lib`**: Contains functions used in your application, such as reusable utility functions and data fetching functions.
-   **`/app/ui`**: Contains all the UI components for your application, such as cards, tables, and forms. To save time, we've pre-styled these components for you.
-   **`/public`**: Contains all the static assets for your application, such as images.
-   **Config Files**: You'll also notice config files such as `next.config.js` at the root of your application. Most of these files are created and pre-configured when you start a new project using `create-next-app`. You will not need to modify them in this course.

Feel free to explore these folders, and don't worry if you don't understand everything the code is doing yet.

### [Placeholder data](https://nextjs.org/learn/dashboard-app/getting-started#placeholder-data)

When you're building user interfaces, it helps to have some placeholder data. If a database or API is not yet available, you can:

-   Use placeholder data in JSON format or as JavaScript objects.
-   Use a 3rd party service like [mockAPI](https://mockapi.io/).

For this project, we've provided some placeholder data in `app/lib/placeholder-data.ts`. Each JavaScript object in the file represents a table in your database. For example, for the invoices table:

```
<span><span>const</span><span> </span><span>invoices</span><span> </span><span>=</span><span> [</span></span>
<span><span>  {</span></span>
<span><span>    customer_id</span><span>:</span><span> customers[</span><span>0</span><span>].id</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>15795</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>'pending'</span><span>,</span></span>
<span><span>    date</span><span>:</span><span> </span><span>'2022-12-06'</span><span>,</span></span>
<span><span>  }</span><span>,</span></span>
<span><span>  {</span></span>
<span><span>    customer_id</span><span>:</span><span> customers[</span><span>1</span><span>].id</span><span>,</span></span>
<span><span>    amount</span><span>:</span><span> </span><span>20348</span><span>,</span></span>
<span><span>    status</span><span>:</span><span> </span><span>'pending'</span><span>,</span></span>
<span><span>    date</span><span>:</span><span> </span><span>'2022-11-14'</span><span>,</span></span>
<span><span>  }</span><span>,</span></span>
<span><span>  </span><span>// ...</span></span>
<span><span>];</span></span>
```

In the chapter on [setting up your database](https://nextjs.org/learn/dashboard-app/setting-up-your-database), you'll use this data to _seed_ your database (populate it with some initial data).

### [TypeScript](https://nextjs.org/learn/dashboard-app/getting-started#typescript)

You may also notice most files have a `.ts` or `.tsx` suffix. This is because the project is written in TypeScript. We wanted to create a course that reflects the modern web landscape.

It's okay if you don't know TypeScript - we'll provide the TypeScript code snippets when required.

For now, take a look at the `/app/lib/definitions.ts` file. Here, we manually define the types that will be returned from the database. For example, the invoices table has the following types:

```
<span><span>export</span><span> </span><span>type</span><span> </span><span>Invoice</span><span> </span><span>=</span><span> {</span></span>
<span><span>  id</span><span>:</span><span> </span><span>string</span><span>;</span></span>
<span><span>  customer_id</span><span>:</span><span> </span><span>string</span><span>;</span></span>
<span><span>  amount</span><span>:</span><span> </span><span>number</span><span>;</span></span>
<span><span>  date</span><span>:</span><span> </span><span>string</span><span>;</span></span>
<span><span>  </span><span>// In TypeScript, this is called a string union type.</span></span>
<span><span>  </span><span>// It means that the "status" property can only be one of the two strings: 'pending' or 'paid'.</span></span>
<span><span>  status</span><span>:</span><span> </span><span>'pending'</span><span> </span><span>|</span><span> </span><span>'paid'</span><span>;</span></span>
<span><span>};</span></span>
```

By using TypeScript, you can ensure you don't accidentally pass the wrong data format to your components or database, like passing a `string` instead of a `number` to invoice `amount`.

> **If you're a TypeScript developer:**
> 
> -   We're manually declaring the data types, but for better type-safety, we recommend [Prisma](https://www.prisma.io/) or [Drizzle](https://orm.drizzle.team/), which automatically generates types based on your database schema.
> -   Next.js detects if your project uses TypeScript and automatically installs the necessary packages and configuration. Next.js also comes with a [TypeScript plugin](https://nextjs.org/docs/app/building-your-application/configuring/typescript#typescript-plugin) for your code editor, to help with auto-completion and type-safety.

## [Running the development server](https://nextjs.org/learn/dashboard-app/getting-started#running-the-development-server)

Run `pnpm i` to install the project's packages.

Followed by `pnpm dev` to start the development server.

`pnpm dev` starts your Next.js development server on port `3000`. Let's check to see if it's working.

Open [http://localhost:3000](http://localhost:3000/) on your browser. Your home page should look like this, which is intentionally unstyled:

![Unstyled page with the title 'Acme', a description, and login link.](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Facme-unstyled.png&w=3840&q=75&dpl=dpl_5DU7MtoYzzYKJbui3G5kbf54JXGA)