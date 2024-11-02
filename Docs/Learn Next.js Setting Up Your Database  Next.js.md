Before you can continue working on your dashboard, you'll need some data. In this chapter, you'll be setting up a PostgreSQL database using `@vercel/postgres`. If you're already familiar with PostgreSQL and would prefer to use your own provider, you can skip this chapter and set it up on your own. Otherwise, let's continue!

In this chapter...

Here are the topics we’ll cover

Push your project to GitHub.

Set up a Vercel account and link your GitHub repo for instant previews and deployments.

Create and link your project to a Postgres database.

Seed the database with initial data.

## [Create a GitHub repository](https://nextjs.org/learn/dashboard-app/setting-up-your-database#create-a-github-repository)

To start, let's push your repository to Github if you haven't done so already. This will make it easier to set up your database and deploy.

If you need help setting up your repository, take a look at [this guide on GitHub](https://help.github.com/en/github/getting-started-with-github/create-a-repo).

> **Good to know:**
> 
> -   You can also use other Git provider like GitLab or Bitbucket.
> -   If you're new to GitHub, we recommend the [GitHub Desktop App](https://desktop.github.com/) for a simplified development workflow.

## [Create a Vercel account](https://nextjs.org/learn/dashboard-app/setting-up-your-database#create-a-vercel-account)

Visit [vercel.com/signup](https://vercel.com/signup) to create an account. Choose the free "hobby" plan. Select **Continue with GitHub** to connect your GitHub and Vercel accounts.

## [Connect and deploy your project](https://nextjs.org/learn/dashboard-app/setting-up-your-database#connect-and-deploy-your-project)

Next, you'll be taken to this screen where you can select and **import** the GitHub repository you've just created:

![Screenshot of Vercel Dashboard, showing the import project screen with a list of the user's GitHub Repositories](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fimport-git-repo.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

Name your project and click **Deploy**.

![Deployment screen showing the project name field and a deploy button](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fconfigure-project.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

Hooray! 🎉 Your project is now deployed.

![Project overview screen showing the project name, domain, and deployment status](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fdeployed-project.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

By connecting your GitHub repository, whenever you push changes to your **main** branch, Vercel will automatically redeploy your application with no configuration needed. When opening pull requests, you'll also have [instant previews](https://vercel.com/docs/deployments/preview-deployments#preview-urls) which allow you to catch deployment errors early and share a preview of your project with team members for feedback.

## [Create a Postgres database](https://nextjs.org/learn/dashboard-app/setting-up-your-database#create-a-postgres-database)

Next, to set up a database, click **Continue to Dashboard** and select the **Storage** tab from your project dashboard. Select **Connect Store** → **Create New** → **Postgres** → **Continue**.

![Connect Store screen showing the Postgres option along with KV, Blob and Edge Config](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fcreate-database.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

Accept the terms, assign a name to your database, and ensure your database region is set to **Washington D.C (iad1)** - this is also the [default region](https://vercel.com/docs/functions/configuring-functions/region) for all new Vercel projects. By placing your database in the same region or close to your application code, you can reduce [latency](https://developer.mozilla.org/en-US/docs/Web/Performance/Understanding_latency) for data requests.

![Database creation modal showing the database name and region](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fdatabase-region.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

> **Good to know**: You cannot change the database region once it has been initalized. If you wish to use a different [region](https://vercel.com/docs/storage/vercel-postgres/limits#supported-regions), you should set it before creating a database.

Once connected, navigate to the `.env.local` tab, click **Show secret** and **Copy Snippet**. Make sure you reveal the secrets before copying them.

![The .env.local tab showing the hidden database secrets](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fdatabase-dashboard.png&w=1920&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

Navigate to your code editor and rename the `.env.example` file to **`.env`**. Paste in the copied contents from Vercel.

**Important:** Go to your `.gitignore` file and make sure `.env` is in the ignored files to prevent your database secrets from being exposed when you push to GitHub.

Finally, run `pnpm i @vercel/postgres` in your terminal to install the [Vercel Postgres SDK](https://vercel.com/docs/storage/vercel-postgres/sdk).

## [Seed your database](https://nextjs.org/learn/dashboard-app/setting-up-your-database#seed-your-database)

Now that your database has been created, let's seed it with some initial data.

Inside of `/app`, there's a folder called `seed`. Uncomment this file. This folder contains a [Next.js Route Handler](https://nextjs.org/docs/app/building-your-application/routing/route-handlers), called `route.ts`, that will be used to seed your database. This creates a server-side endpoint that you can access in the browser to start populating your database.

Don't worry if you don't understand everything the code is doing, but to give you an overview, the script uses **SQL** to create the tables, and the data from `placeholder-data.ts` file to populate them after they've been created.

Ensure your local development server is running with `pnpm run dev` and navigate to [`localhost:3000/seed`](http://localhost:3000/seed) in your browser. When finished, you will see a message "Database seeded successfully" in the browser. Once completed, you can delete this file.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

What is 'seeding' in the context of databases?

> **Troubleshooting**:
> 
> -   Make sure to reveal your database secrets before copying it into your `.env` file.
> -   The script uses `bcrypt` to hash the user's password, if `bcrypt` isn't compatible with your environment, you can update the script to use [`bcryptjs`](https://www.npmjs.com/package/bcryptjs) instead.
> -   If you run into any issues while seeding your database and want to run the script again, you can drop any existing tables by running `DROP TABLE tablename` in your database query interface. See the [executing queries section](https://nextjs.org/learn/dashboard-app/setting-up-your-database#executing-queries) below for more details. But be careful, this command will delete the tables and all their data. It's ok to do this with your example app since you're working with placeholder data, but you shouldn't run this command in a production app.
> -   If you continue to experience issues while seeding your Vercel Postgres database, please open a [discussion on GitHub](https://github.com/vercel/next-learn/issues).

## [Exploring your database](https://nextjs.org/learn/dashboard-app/setting-up-your-database#exploring-your-database)

Let's see what your database looks like. Go back to Vercel, and click **Data** on the sidenav.

In this section, you'll find the four new tables: users, customers, invoices, and revenue.

![Database screen showing dropdown list with four tables: users, customers, invoices, and revenue](https://nextjs.org/_next/image?url=%2Flearn%2Fdark%2Fdatabase-tables.png&w=2048&q=75&dpl=dpl_BpKziPZ8D8KdgtcNYEQc9tyDG4N7)

By selecting each table, you can view its records and ensure the entries align with the data from `placeholder-data.ts` file.

## [Executing queries](https://nextjs.org/learn/dashboard-app/setting-up-your-database#executing-queries)

You can switch to the "query" tab to interact with your database. This section supports standard SQL commands. For instance, inputting `DROP TABLE customers` will delete "customers" table along with all its data - **_so be careful_**!

Let's run your first database query. Paste and run the following SQL code into the Vercel interface:

```
<span><span>SELECT</span><span> invoices.amount, customers.name</span></span>
<span><span>FROM</span><span> invoices</span></span>
<span><span>JOIN</span><span> customers </span><span>ON</span><span> invoices.customer_id </span><span>=</span><span> customers.id</span></span>
<span><span>WHERE</span><span> invoices.amount </span><span>=</span><span> </span><span>666</span><span>;</span></span>
```

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

Which customer does this invoice belong to?