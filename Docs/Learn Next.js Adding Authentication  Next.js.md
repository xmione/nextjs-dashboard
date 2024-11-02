In the previous chapter, you finished building the invoices routes by adding form validation and improving accessibility. In this chapter, you'll be adding authentication to your dashboard.

In this chapter...

Here are the topics we’ll cover

How to add authentication to your app using NextAuth.js.

How to use Middleware to redirect users and protect your routes.

How to use React's `useActionState` to handle pending states and form errors.

## [What is authentication?](https://nextjs.org/learn/dashboard-app/adding-authentication#what-is-authentication)

Authentication is a key part of many web applications today. It's how a system checks if the user is who they say they are.

A secure website often uses multiple ways to check a user's identity. For instance, after entering your username and password, the site may send a verification code to your device or use an external app like Google Authenticator. This 2-factor authentication (2FA) helps increase security. Even if someone learns your password, they can't access your account without your unique token.

In web development, authentication and authorization serve different roles:

-   **Authentication** is about making sure the user is who they say they are. You're proving your identity with something you have like a username and password.
-   **Authorization** is the next step. Once a user's identity is confirmed, authorization decides what parts of the application they are allowed to use.

So, authentication checks who you are, and authorization determines what you can do or access in the application.

### It’s time to take a quiz!

Test your knowledge and see what you’ve just learned.

Which of the following best describes the difference between authentication and authorization?

## [Creating the login route](https://nextjs.org/learn/dashboard-app/adding-authentication#creating-the-login-route)

Start by creating a new route in your application called `/login` and paste the following code:

```
<span><span>import</span><span> AcmeLogo </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/acme-logo'</span><span>;</span></span>
<span><span>import</span><span> LoginForm </span><span>from</span><span> </span><span>'@/</span><span>app</span><span>/ui/login-form'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>LoginPage</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>main</span><span> </span><span>className</span><span>=</span><span>"flex items-center justify-center md:h-screen"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"relative mx-auto flex w-full max-w-[400px] flex-col space-y-2.5 p-4 md:-mt-32"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"flex h-20 w-full items-end rounded-lg bg-blue-500 p-3 md:h-36"</span><span>&gt;</span></span>
<span><span>          &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"w-32 text-white md:w-36"</span><span>&gt;</span></span>
<span><span>            &lt;</span><span>AcmeLogo</span><span> /&gt;</span></span>
<span><span>          &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>        &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>LoginForm</span><span> /&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>main</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

You'll notice the page imports `<LoginForm />`, which you'll update later in the chapter.

## [NextAuth.js](https://nextjs.org/learn/dashboard-app/adding-authentication#nextauthjs)

We will be using [NextAuth.js](https://nextjs.authjs.dev/) to add authentication to your application. NextAuth.js abstracts away much of the complexity involved in managing sessions, sign-in and sign-out, and other aspects of authentication. While you can manually implement these features, the process can be time-consuming and error-prone. NextAuth.js simplifies the process, providing a unified solution for auth in Next.js applications.

## [Setting up NextAuth.js](https://nextjs.org/learn/dashboard-app/adding-authentication#setting-up-nextauthjs)

Install NextAuth.js by running the following command in your terminal:

Here, you're installing the `beta` version of NextAuth.js, which is compatible with Next.js 14.

Next, generate a secret key for your application. This key is used to encrypt cookies, ensuring the security of user sessions. You can do this by running the following command in your terminal:

Then, in your `.env` file, add your generated key to the `AUTH_SECRET` variable:

```
<span><span>AUTH_SECRET</span><span>=</span><span>your-secret-key</span></span>
```

For auth to work in production, you'll need to update your environment variables in your Vercel project too. Check out this [guide](https://vercel.com/docs/projects/environment-variables) on how to add environment variables on Vercel.

### [Adding the pages option](https://nextjs.org/learn/dashboard-app/adding-authentication#adding-the-pages-option)

Create an `auth.config.ts` file at the root of our project that exports an `authConfig` object. This object will contain the configuration options for NextAuth.js. For now, it will only contain the `pages` option:

```
<span><span>import</span><span> </span><span>type</span><span> { NextAuthConfig } </span><span>from</span><span> </span><span>'next-auth'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> </span><span>authConfig</span><span> </span><span>=</span><span> {</span></span>
<span><span>  pages</span><span>:</span><span> {</span></span>
<span><span>    signIn</span><span>:</span><span> </span><span>'/login'</span><span>,</span></span>
<span><span>  }</span><span>,</span></span>
<span><span>} </span><span>satisfies</span><span> </span><span>NextAuthConfig</span><span>;</span></span>
```

You can use the `pages` option to specify the route for custom sign-in, sign-out, and error pages. This is not required, but by adding `signIn: '/login'` into our `pages` option, the user will be redirected to our custom login page, rather than the NextAuth.js default page.

## [Protecting your routes with Next.js Middleware](https://nextjs.org/learn/dashboard-app/adding-authentication#protecting-your-routes-with-nextjs-middleware)

Next, add the logic to protect your routes. This will prevent users from accessing the dashboard pages unless they are logged in.

```
<span><span>import</span><span> </span><span>type</span><span> { NextAuthConfig } </span><span>from</span><span> </span><span>'next-auth'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> </span><span>authConfig</span><span> </span><span>=</span><span> {</span></span>
<span><span>  pages</span><span>:</span><span> {</span></span>
<span><span>    signIn</span><span>:</span><span> </span><span>'/login'</span><span>,</span></span>
<span><span>  }</span><span>,</span></span>
<span><span>  callbacks</span><span>:</span><span> {</span></span>
<span><span>    </span><span>authorized</span><span>({ auth</span><span>,</span><span> request: { nextUrl } }) {</span></span>
<span><span>      </span><span>const</span><span> </span><span>isLoggedIn</span><span> </span><span>=</span><span> </span><span>!!</span><span>auth</span><span>?.user;</span></span>
<span><span>      </span><span>const</span><span> </span><span>isOnDashboard</span><span> </span><span>=</span><span> </span><span>nextUrl</span><span>.</span><span>pathname</span><span>.startsWith</span><span>(</span><span>'/dashboard'</span><span>);</span></span>
<span><span>      </span><span>if</span><span> (isOnDashboard) {</span></span>
<span><span>        </span><span>if</span><span> (isLoggedIn) </span><span>return</span><span> </span><span>true</span><span>;</span></span>
<span><span>        </span><span>return</span><span> </span><span>false</span><span>; </span><span>// Redirect unauthenticated users to login page</span></span>
<span><span>      } </span><span>else</span><span> </span><span>if</span><span> (isLoggedIn) {</span></span>
<span><span>        </span><span>return</span><span> </span><span>Response</span><span>.redirect</span><span>(</span><span>new</span><span> </span><span>URL</span><span>(</span><span>'/dashboard'</span><span>,</span><span> nextUrl));</span></span>
<span><span>      }</span></span>
<span><span>      </span><span>return</span><span> </span><span>true</span><span>;</span></span>
<span><span>    }</span><span>,</span></span>
<span><span>  }</span><span>,</span></span>
<span><span>  providers</span><span>:</span><span> []</span><span>,</span><span> </span><span>// Add providers with an empty array for now</span></span>
<span><span>} </span><span>satisfies</span><span> </span><span>NextAuthConfig</span><span>;</span></span>
```

The `authorized` callback is used to verify if the request is authorized to access a page via [Next.js Middleware](https://nextjs.org/docs/app/building-your-application/routing/middleware). It is called before a request is completed, and it receives an object with the `auth` and `request` properties. The `auth` property contains the user's session, and the `request` property contains the incoming request.

The `providers` option is an array where you list different login options. For now, it's an empty array to satisfy NextAuth config. You'll learn more about it in the [Adding the Credentials provider](https://nextjs.org/learn/dashboard-app/adding-authentication#adding-the-credentials-provider) section.

Next, you will need to import the `authConfig` object into a Middleware file. In the root of your project, create a file called `middleware.ts` and paste the following code:

```
<span><span>import</span><span> NextAuth </span><span>from</span><span> </span><span>'next-auth'</span><span>;</span></span>
<span><span>import</span><span> { authConfig } </span><span>from</span><span> </span><span>'./auth.config'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>NextAuth</span><span>(authConfig).auth;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> </span><span>config</span><span> </span><span>=</span><span> {</span></span>
<span><span>  </span><span>// https://nextjs.org/docs/app/building-your-application/routing/middleware#matcher</span></span>
<span><span>  matcher</span><span>:</span><span> [</span><span>'/((?!api|_next/static|_next/image|.*\\.png$).*)'</span><span>]</span><span>,</span></span>
<span><span>};</span></span>
```

Here you're initializing NextAuth.js with the `authConfig` object and exporting the `auth` property. You're also using the `matcher` option from Middleware to specify that it should run on specific paths.

The advantage of employing Middleware for this task is that the protected routes will not even start rendering until the Middleware verifies the authentication, enhancing both the security and performance of your application.

### [Password hashing](https://nextjs.org/learn/dashboard-app/adding-authentication#password-hashing)

It's good practice to **hash** passwords before storing them in a database. Hashing converts a password into a fixed-length string of characters, which appears random, providing a layer of security even if the user's data is exposed.

In your `seed.js` file, you used a package called `bcrypt` to hash the user's password before storing it in the database. You will use it _again_ later in this chapter to compare that the password entered by the user matches the one in the database. However, you will need to create a separate file for the `bcrypt` package. This is because `bcrypt` relies on Node.js APIs not available in Next.js Middleware.

Create a new file called `auth.ts` that spreads your `authConfig` object:

```
<span><span>import</span><span> NextAuth </span><span>from</span><span> </span><span>'next-auth'</span><span>;</span></span>
<span><span>import</span><span> { authConfig } </span><span>from</span><span> </span><span>'./auth.config'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> { </span><span>auth</span><span>,</span><span> </span><span>signIn</span><span>,</span><span> </span><span>signOut</span><span> } </span><span>=</span><span> </span><span>NextAuth</span><span>({</span></span>
<span><span>  </span><span>...</span><span>authConfig</span><span>,</span></span>
<span><span>});</span></span>
```

### [Adding the Credentials provider](https://nextjs.org/learn/dashboard-app/adding-authentication#adding-the-credentials-provider)

Next, you will need to add the `providers` option for NextAuth.js. `providers` is an array where you list different login options such as Google or GitHub. For this course, we will focus on using the [Credentials provider](https://authjs.dev/getting-started/providers/credentials-tutorial) only.

The Credentials provider allows users to log in with a username and a password.

```
<span><span>import</span><span> NextAuth </span><span>from</span><span> </span><span>'next-auth'</span><span>;</span></span>
<span><span>import</span><span> { authConfig } </span><span>from</span><span> </span><span>'./auth.config'</span><span>;</span></span>
<span><span>import</span><span> Credentials </span><span>from</span><span> </span><span>'next-auth/providers/credentials'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> { </span><span>auth</span><span>,</span><span> </span><span>signIn</span><span>,</span><span> </span><span>signOut</span><span> } </span><span>=</span><span> </span><span>NextAuth</span><span>({</span></span>
<span><span>  </span><span>...</span><span>authConfig</span><span>,</span></span>
<span><span>  providers</span><span>:</span><span> [</span><span>Credentials</span><span>({})]</span><span>,</span></span>
<span><span>});</span></span>
```

> **Good to know:**
> 
> Although we're using the Credentials provider, it's generally recommended to use alternative providers such as [OAuth](https://authjs.dev/getting-started/providers/oauth-tutorial) or [email](https://authjs.dev/getting-started/providers/email-tutorial) providers. See the [NextAuth.js docs](https://authjs.dev/getting-started/providers) for a full list of options.

### [Adding the sign in functionality](https://nextjs.org/learn/dashboard-app/adding-authentication#adding-the-sign-in-functionality)

You can use the `authorize` function to handle the authentication logic. Similarly to Server Actions, you can use `zod` to validate the email and password before checking if the user exists in the database:

```
<span><span>import</span><span> NextAuth </span><span>from</span><span> </span><span>'next-auth'</span><span>;</span></span>
<span><span>import</span><span> { authConfig } </span><span>from</span><span> </span><span>'./auth.config'</span><span>;</span></span>
<span><span>import</span><span> Credentials </span><span>from</span><span> </span><span>'next-auth/providers/credentials'</span><span>;</span></span>
<span><span>import</span><span> { z } </span><span>from</span><span> </span><span>'zod'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> { </span><span>auth</span><span>,</span><span> </span><span>signIn</span><span>,</span><span> </span><span>signOut</span><span> } </span><span>=</span><span> </span><span>NextAuth</span><span>({</span></span>
<span><span>  </span><span>...</span><span>authConfig</span><span>,</span></span>
<span><span>  providers</span><span>:</span><span> [</span></span>
<span><span>    </span><span>Credentials</span><span>({</span></span>
<span><span>      </span><span>async</span><span> </span><span>authorize</span><span>(credentials) {</span></span>
<span><span>        </span><span>const</span><span> </span><span>parsedCredentials</span><span> </span><span>=</span><span> z</span></span>
<span><span>          </span><span>.object</span><span>({ email</span><span>:</span><span> </span><span>z</span><span>.string</span><span>()</span><span>.email</span><span>()</span><span>,</span><span> password</span><span>:</span><span> </span><span>z</span><span>.string</span><span>()</span><span>.min</span><span>(</span><span>6</span><span>) })</span></span>
<span><span>          </span><span>.safeParse</span><span>(credentials);</span></span>
<span><span>      }</span><span>,</span></span>
<span><span>    })</span><span>,</span></span>
<span><span>  ]</span><span>,</span></span>
<span><span>});</span></span>
```

After validating the credentials, create a new `getUser` function that queries the user from the database.

```
<span><span>import</span><span> NextAuth </span><span>from</span><span> </span><span>'next-auth'</span><span>;</span></span>
<span><span>import</span><span> Credentials </span><span>from</span><span> </span><span>'next-auth/providers/credentials'</span><span>;</span></span>
<span><span>import</span><span> { authConfig } </span><span>from</span><span> </span><span>'./auth.config'</span><span>;</span></span>
<span><span>import</span><span> { z } </span><span>from</span><span> </span><span>'zod'</span><span>;</span></span>
<span><span>import</span><span> { sql } </span><span>from</span><span> </span><span>'@vercel/postgres'</span><span>;</span></span>
<span><span>import</span><span> </span><span>type</span><span> { User } </span><span>from</span><span> </span><span>'@/app/lib/definitions'</span><span>;</span></span>
<span><span>import</span><span> bcrypt </span><span>from</span><span> </span><span>'bcrypt'</span><span>;</span></span>
<span> </span>
<span><span>async</span><span> </span><span>function</span><span> </span><span>getUser</span><span>(email</span><span>:</span><span> </span><span>string</span><span>)</span><span>:</span><span> </span><span>Promise</span><span>&lt;</span><span>User</span><span> </span><span>|</span><span> </span><span>undefined</span><span>&gt; {</span></span>
<span><span>  </span><span>try</span><span> {</span></span>
<span><span>    </span><span>const</span><span> </span><span>user</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>sql</span><span>&lt;</span><span>User</span><span>&gt;`SELECT * FROM users WHERE email=</span><span>${</span><span>email</span><span>}</span><span>`</span><span>;</span></span>
<span><span>    </span><span>return</span><span> </span><span>user</span><span>.rows[</span><span>0</span><span>];</span></span>
<span><span>  } </span><span>catch</span><span> (error) {</span></span>
<span><span>    </span><span>console</span><span>.error</span><span>(</span><span>'Failed to fetch user:'</span><span>,</span><span> error);</span></span>
<span><span>    </span><span>throw</span><span> </span><span>new</span><span> </span><span>Error</span><span>(</span><span>'Failed to fetch user.'</span><span>);</span></span>
<span><span>  }</span></span>
<span><span>}</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> { </span><span>auth</span><span>,</span><span> </span><span>signIn</span><span>,</span><span> </span><span>signOut</span><span> } </span><span>=</span><span> </span><span>NextAuth</span><span>({</span></span>
<span><span>  </span><span>...</span><span>authConfig</span><span>,</span></span>
<span><span>  providers</span><span>:</span><span> [</span></span>
<span><span>    </span><span>Credentials</span><span>({</span></span>
<span><span>      </span><span>async</span><span> </span><span>authorize</span><span>(credentials) {</span></span>
<span><span>        </span><span>const</span><span> </span><span>parsedCredentials</span><span> </span><span>=</span><span> z</span></span>
<span><span>          </span><span>.object</span><span>({ email</span><span>:</span><span> </span><span>z</span><span>.string</span><span>()</span><span>.email</span><span>()</span><span>,</span><span> password</span><span>:</span><span> </span><span>z</span><span>.string</span><span>()</span><span>.min</span><span>(</span><span>6</span><span>) })</span></span>
<span><span>          </span><span>.safeParse</span><span>(credentials);</span></span>
<span> </span>
<span><span>        </span><span>if</span><span> (</span><span>parsedCredentials</span><span>.success) {</span></span>
<span><span>          </span><span>const</span><span> { </span><span>email</span><span>,</span><span> </span><span>password</span><span> } </span><span>=</span><span> </span><span>parsedCredentials</span><span>.data;</span></span>
<span><span>          </span><span>const</span><span> </span><span>user</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>getUser</span><span>(email);</span></span>
<span><span>          </span><span>if</span><span> (</span><span>!</span><span>user) </span><span>return</span><span> </span><span>null</span><span>;</span></span>
<span><span>        }</span></span>
<span> </span>
<span><span>        </span><span>return</span><span> </span><span>null</span><span>;</span></span>
<span><span>      }</span><span>,</span></span>
<span><span>    })</span><span>,</span></span>
<span><span>  ]</span><span>,</span></span>
<span><span>});</span></span>
```

Then, call `bcrypt.compare` to check if the passwords match:

```
<span><span>import</span><span> NextAuth </span><span>from</span><span> </span><span>'next-auth'</span><span>;</span></span>
<span><span>import</span><span> Credentials </span><span>from</span><span> </span><span>'next-auth/providers/credentials'</span><span>;</span></span>
<span><span>import</span><span> { authConfig } </span><span>from</span><span> </span><span>'./auth.config'</span><span>;</span></span>
<span><span>import</span><span> { sql } </span><span>from</span><span> </span><span>'@vercel/postgres'</span><span>;</span></span>
<span><span>import</span><span> { z } </span><span>from</span><span> </span><span>'zod'</span><span>;</span></span>
<span><span>import</span><span> </span><span>type</span><span> { User } </span><span>from</span><span> </span><span>'@/app/lib/definitions'</span><span>;</span></span>
<span><span>import</span><span> bcrypt </span><span>from</span><span> </span><span>'bcrypt'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>const</span><span> { </span><span>auth</span><span>,</span><span> </span><span>signIn</span><span>,</span><span> </span><span>signOut</span><span> } </span><span>=</span><span> </span><span>NextAuth</span><span>({</span></span>
<span><span>  </span><span>...</span><span>authConfig</span><span>,</span></span>
<span><span>  providers</span><span>:</span><span> [</span></span>
<span><span>    </span><span>Credentials</span><span>({</span></span>
<span><span>      </span><span>async</span><span> </span><span>authorize</span><span>(credentials) {</span></span>
<span><span>        </span><span>// ...</span></span>
<span> </span>
<span><span>        </span><span>if</span><span> (</span><span>parsedCredentials</span><span>.success) {</span></span>
<span><span>          </span><span>const</span><span> { </span><span>email</span><span>,</span><span> </span><span>password</span><span> } </span><span>=</span><span> </span><span>parsedCredentials</span><span>.data;</span></span>
<span><span>          </span><span>const</span><span> </span><span>user</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>getUser</span><span>(email);</span></span>
<span><span>          </span><span>if</span><span> (</span><span>!</span><span>user) </span><span>return</span><span> </span><span>null</span><span>;</span></span>
<span><span>          </span><span>const</span><span> </span><span>passwordsMatch</span><span> </span><span>=</span><span> </span><span>await</span><span> </span><span>bcrypt</span><span>.compare</span><span>(password</span><span>,</span><span> </span><span>user</span><span>.password);</span></span>
<span> </span>
<span><span>          </span><span>if</span><span> (passwordsMatch) </span><span>return</span><span> user;</span></span>
<span><span>        }</span></span>
<span> </span>
<span><span>        </span><span>console</span><span>.log</span><span>(</span><span>'Invalid credentials'</span><span>);</span></span>
<span><span>        </span><span>return</span><span> </span><span>null</span><span>;</span></span>
<span><span>      }</span><span>,</span></span>
<span><span>    })</span><span>,</span></span>
<span><span>  ]</span><span>,</span></span>
<span><span>});</span></span>
```

Finally, if the passwords match you want to return the user, otherwise, return `null` to prevent the user from logging in.

### [Updating the login form](https://nextjs.org/learn/dashboard-app/adding-authentication#updating-the-login-form)

Now you need to connect the auth logic with your login form. In your `actions.ts` file, create a new action called `authenticate`. This action should import the `signIn` function from `auth.ts`:

```
<span><span>'use server'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { signIn } </span><span>from</span><span> </span><span>'@/auth'</span><span>;</span></span>
<span><span>import</span><span> { AuthError } </span><span>from</span><span> </span><span>'next-auth'</span><span>;</span></span>
<span> </span>
<span><span>// ...</span></span>
<span> </span>
<span><span>export</span><span> </span><span>async</span><span> </span><span>function</span><span> </span><span>authenticate</span><span>(</span></span>
<span><span>  prevState</span><span>:</span><span> </span><span>string</span><span> </span><span>|</span><span> </span><span>undefined</span><span>,</span></span>
<span><span>  formData</span><span>:</span><span> </span><span>FormData</span><span>,</span></span>
<span><span>) {</span></span>
<span><span>  </span><span>try</span><span> {</span></span>
<span><span>    </span><span>await</span><span> </span><span>signIn</span><span>(</span><span>'credentials'</span><span>,</span><span> formData);</span></span>
<span><span>  } </span><span>catch</span><span> (error) {</span></span>
<span><span>    </span><span>if</span><span> (error </span><span>instanceof</span><span> </span><span>AuthError</span><span>) {</span></span>
<span><span>      </span><span>switch</span><span> (</span><span>error</span><span>.type) {</span></span>
<span><span>        </span><span>case</span><span> </span><span>'CredentialsSignin'</span><span>:</span></span>
<span><span>          </span><span>return</span><span> </span><span>'Invalid credentials.'</span><span>;</span></span>
<span><span>        </span><span>default</span><span>:</span></span>
<span><span>          </span><span>return</span><span> </span><span>'Something went wrong.'</span><span>;</span></span>
<span><span>      }</span></span>
<span><span>    }</span></span>
<span><span>    </span><span>throw</span><span> error;</span></span>
<span><span>  }</span></span>
<span><span>}</span></span>
```

If there's a `'CredentialsSignin'` error, you want to show an appropriate error message. You can learn about NextAuth.js errors in [the documentation](https://errors.authjs.dev/)

Finally, in your `login-form.tsx` component, you can use React's `useActionState` to call the server action, handle form errors, and display the form's pending state:

```
<span><span>'use client'</span><span>;</span></span>
<span> </span>
<span><span>import</span><span> { lusitana } </span><span>from</span><span> </span><span>'@/app/</span><span>ui</span><span>/fonts'</span><span>;</span></span>
<span><span>import</span><span> {</span></span>
<span><span>  AtSymbolIcon</span><span>,</span></span>
<span><span>  KeyIcon</span><span>,</span></span>
<span><span>  ExclamationCircleIcon</span><span>,</span></span>
<span><span>} </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> { ArrowRightIcon } </span><span>from</span><span> </span><span>'@heroicons/react/20/solid'</span><span>;</span></span>
<span><span>import</span><span> { Button } </span><span>from</span><span> </span><span>'@/app/</span><span>ui</span><span>/button'</span><span>;</span></span>
<span><span>import</span><span> { useActionState } </span><span>from</span><span> </span><span>'react'</span><span>;</span></span>
<span><span>import</span><span> { authenticate } </span><span>from</span><span> </span><span>'@/app/lib/actions'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>LoginForm</span><span>() {</span></span>
<span><span>  </span><span>const</span><span> [</span><span>errorMessage</span><span>,</span><span> </span><span>formAction</span><span>,</span><span> </span><span>isPending</span><span>] </span><span>=</span><span> </span><span>useActionState</span><span>(</span></span>
<span><span>    authenticate</span><span>,</span></span>
<span><span>    </span><span>undefined</span><span>,</span></span>
<span><span>  );</span></span>
<span> </span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>form</span><span> </span><span>action</span><span>=</span><span>{formAction} </span><span>className</span><span>=</span><span>"space-y-3"</span><span>&gt;</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"flex-1 rounded-lg bg-gray-50 px-6 pb-4 pt-8"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>h1</span><span> </span><span>className</span><span>=</span><span>{</span><span>`</span><span>${</span><span>lusitana</span><span>.className</span><span>}</span><span> mb-3 text-2xl`</span><span>}&gt;</span></span>
<span><span>          Please log in to continue.</span></span>
<span><span>        &lt;/</span><span>h1</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"w-full"</span><span>&gt;</span></span>
<span><span>          &lt;</span><span>div</span><span>&gt;</span></span>
<span><span>            &lt;</span><span>label</span></span>
<span><span>              </span><span>className</span><span>=</span><span>"mb-3 mt-5 block text-xs font-medium text-gray-900"</span></span>
<span><span>              </span><span>htmlFor</span><span>=</span><span>"email"</span></span>
<span><span>            &gt;</span></span>
<span><span>              Email</span></span>
<span><span>            &lt;/</span><span>label</span><span>&gt;</span></span>
<span><span>            &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"relative"</span><span>&gt;</span></span>
<span><span>              &lt;</span><span>input</span></span>
<span><span>                </span><span>className</span><span>=</span><span>"peer block w-full rounded-md border border-gray-200 py-[9px] pl-10 text-sm outline-2 placeholder:text-gray-500"</span></span>
<span><span>                </span><span>id</span><span>=</span><span>"email"</span></span>
<span><span>                </span><span>type</span><span>=</span><span>"email"</span></span>
<span><span>                </span><span>name</span><span>=</span><span>"email"</span></span>
<span><span>                </span><span>placeholder</span><span>=</span><span>"Enter your email address"</span></span>
<span><span>                </span><span>req</span><span>ui</span><span>red</span></span>
<span><span>              /&gt;</span></span>
<span><span>              &lt;</span><span>AtSymbolIcon</span><span> </span><span>className</span><span>=</span><span>"pointer-events-none absolute left-3 top-1/2 h-[18px] w-[18px] -translate-y-1/2 text-gray-500 peer-focus:text-gray-900"</span><span> /&gt;</span></span>
<span><span>            &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>          &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>          &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"mt-4"</span><span>&gt;</span></span>
<span><span>            &lt;</span><span>label</span></span>
<span><span>              </span><span>className</span><span>=</span><span>"mb-3 mt-5 block text-xs font-medium text-gray-900"</span></span>
<span><span>              </span><span>htmlFor</span><span>=</span><span>"password"</span></span>
<span><span>            &gt;</span></span>
<span><span>              Password</span></span>
<span><span>            &lt;/</span><span>label</span><span>&gt;</span></span>
<span><span>            &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"relative"</span><span>&gt;</span></span>
<span><span>              &lt;</span><span>input</span></span>
<span><span>                </span><span>className</span><span>=</span><span>"peer block w-full rounded-md border border-gray-200 py-[9px] pl-10 text-sm outline-2 placeholder:text-gray-500"</span></span>
<span><span>                </span><span>id</span><span>=</span><span>"password"</span></span>
<span><span>                </span><span>type</span><span>=</span><span>"password"</span></span>
<span><span>                </span><span>name</span><span>=</span><span>"password"</span></span>
<span><span>                </span><span>placeholder</span><span>=</span><span>"Enter password"</span></span>
<span><span>                </span><span>req</span><span>ui</span><span>red</span></span>
<span><span>                </span><span>minLength</span><span>=</span><span>{</span><span>6</span><span>}</span></span>
<span><span>              /&gt;</span></span>
<span><span>              &lt;</span><span>KeyIcon</span><span> </span><span>className</span><span>=</span><span>"pointer-events-none absolute left-3 top-1/2 h-[18px] w-[18px] -translate-y-1/2 text-gray-500 peer-focus:text-gray-900"</span><span> /&gt;</span></span>
<span><span>            &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>          &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>        &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>Button</span><span> </span><span>className</span><span>=</span><span>"mt-4 w-full"</span><span> </span><span>aria-disabled</span><span>=</span><span>{isPending}&gt;</span></span>
<span><span>          Log in &lt;</span><span>ArrowRightIcon</span><span> </span><span>className</span><span>=</span><span>"ml-auto h-5 w-5 text-gray-50"</span><span> /&gt;</span></span>
<span><span>        &lt;/</span><span>Button</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>div</span></span>
<span><span>          </span><span>className</span><span>=</span><span>"flex h-8 items-end space-x-1"</span></span>
<span><span>          </span><span>aria-live</span><span>=</span><span>"polite"</span></span>
<span><span>          </span><span>aria-atomic</span><span>=</span><span>"true"</span></span>
<span><span>        &gt;</span></span>
<span><span>          {errorMessage </span><span>&amp;&amp;</span><span> (</span></span>
<span><span>            &lt;&gt;</span></span>
<span><span>              &lt;</span><span>ExclamationCircleIcon</span><span> </span><span>className</span><span>=</span><span>"h-5 w-5 text-red-500"</span><span> /&gt;</span></span>
<span><span>              &lt;</span><span>p</span><span> </span><span>className</span><span>=</span><span>"text-sm text-red-500"</span><span>&gt;{errorMessage}&lt;/</span><span>p</span><span>&gt;</span></span>
<span><span>            &lt;/&gt;</span></span>
<span><span>          )}</span></span>
<span><span>        &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>form</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

## [Adding the logout functionality](https://nextjs.org/learn/dashboard-app/adding-authentication#adding-the-logout-functionality)

To add the logout functionality to `<SideNav />`, call the `signOut` function from `auth.ts` in your `<form>` element:

```
<span><span>import</span><span> Link </span><span>from</span><span> </span><span>'next/link'</span><span>;</span></span>
<span><span>import</span><span> NavLinks </span><span>from</span><span> </span><span>'@/app/</span><span>ui</span><span>/dashboard/nav-links'</span><span>;</span></span>
<span><span>import</span><span> AcmeLogo </span><span>from</span><span> </span><span>'@/app/</span><span>ui</span><span>/acme-logo'</span><span>;</span></span>
<span><span>import</span><span> { PowerIcon } </span><span>from</span><span> </span><span>'@heroicons/react/24/outline'</span><span>;</span></span>
<span><span>import</span><span> { signOut } </span><span>from</span><span> </span><span>'@/auth'</span><span>;</span></span>
<span> </span>
<span><span>export</span><span> </span><span>default</span><span> </span><span>function</span><span> </span><span>SideNav</span><span>() {</span></span>
<span><span>  </span><span>return</span><span> (</span></span>
<span><span>    &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"flex h-full flex-col px-3 py-4 md:px-2"</span><span>&gt;</span></span>
<span><span>      // ...</span></span>
<span><span>      &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"flex grow flex-row justify-between space-x-2 md:flex-col md:space-x-0 md:space-y-2"</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>NavLinks</span><span> /&gt;</span></span>
<span><span>        &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"hidden h-auto w-full grow rounded-md bg-gray-50 md:block"</span><span>&gt;&lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>        &lt;</span><span>form</span></span>
<span><span>          </span><span>action</span><span>=</span><span>{</span><span>async</span><span> () </span><span>=&gt;</span><span> {</span></span>
<span><span>            </span><span>'use server'</span><span>;</span></span>
<span><span>            </span><span>await</span><span> </span><span>signOut</span><span>();</span></span>
<span><span>          }}</span></span>
<span><span>        &gt;</span></span>
<span><span>          &lt;</span><span>button</span><span> </span><span>className</span><span>=</span><span>"flex h-[48px] grow items-center justify-center gap-2 rounded-md bg-gray-50 p-3 text-sm font-medium hover:bg-sky-100 hover:text-blue-600 md:flex-none md:justify-start md:p-2 md:px-3"</span><span>&gt;</span></span>
<span><span>            &lt;</span><span>PowerIcon</span><span> </span><span>className</span><span>=</span><span>"w-6"</span><span> /&gt;</span></span>
<span><span>            &lt;</span><span>div</span><span> </span><span>className</span><span>=</span><span>"hidden md:block"</span><span>&gt;Sign Out&lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>          &lt;/</span><span>button</span><span>&gt;</span></span>
<span><span>        &lt;/</span><span>form</span><span>&gt;</span></span>
<span><span>      &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>    &lt;/</span><span>div</span><span>&gt;</span></span>
<span><span>  );</span></span>
<span><span>}</span></span>
```

## [Try it out](https://nextjs.org/learn/dashboard-app/adding-authentication#try-it-out)

Now, try it out. You should be able to log in and out of your application using the following credentials:

-   Email: `user@nextmail.com`
-   Password: `123456`