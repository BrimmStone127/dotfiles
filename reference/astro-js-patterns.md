# Astro & Functional JS Reference

Quick reference for common patterns. Use `/search` in vim or `Ctrl+F` in any editor.

---

## Table of Contents

- [Astro Components](#astro-components)
- [Astro API Routes](#astro-api-routes)
- [Data Fetching](#data-fetching)
- [Functional JS Patterns](#functional-js-patterns)
- [Array Operations](#array-operations)
- [Object Operations](#object-operations)
- [Async Patterns](#async-patterns)
- [Error Handling](#error-handling)
- [TypeScript Patterns](#typescript-patterns)
- [DOM & Events](#dom--events)
- [Forms](#forms)
- [Local Storage](#local-storage)
- [URL & Query Params](#url--query-params)
- [Dates](#dates)
- [Validation](#validation)
- [Firestore Patterns](#firestore-patterns)

---

## Astro Components

### Basic Component
```astro
---
// Server-side code runs at build/request time
interface Props {
  title: string;
  count?: number;
}

const { title, count = 0 } = Astro.props;
const items = await fetch('/api/items').then(r => r.json());
---

<div class="component">
  <h2>{title}</h2>
  <span>Count: {count}</span>

  {items.map(item => (
    <p>{item.name}</p>
  ))}
</div>

<style>
  .component {
    padding: 1rem;
  }
</style>
```

### Conditional Rendering
```astro
---
const { isLoggedIn, user } = Astro.props;
---

{isLoggedIn && <p>Welcome, {user.name}</p>}

{isLoggedIn ? (
  <a href="/dashboard">Dashboard</a>
) : (
  <a href="/login">Login</a>
)}

{items.length > 0 ? (
  <ul>
    {items.map(item => <li>{item}</li>)}
  </ul>
) : (
  <p>No items found</p>
)}
```

### Slots
```astro
---
// Card.astro
interface Props {
  title: string;
}
const { title } = Astro.props;
---

<div class="card">
  <h3>{title}</h3>
  <slot />  <!-- Default slot -->
  <footer>
    <slot name="footer" />  <!-- Named slot -->
  </footer>
</div>

<!-- Usage -->
<Card title="My Card">
  <p>Card content goes here</p>
  <div slot="footer">Footer content</div>
</Card>
```

### Dynamic Tags
```astro
---
interface Props {
  as?: 'h1' | 'h2' | 'h3' | 'p';
}
const { as: Tag = 'p' } = Astro.props;
---

<Tag class="text">{Astro.slots.render('default')}</Tag>
```

### Get URL/Params
```astro
---
// Access current URL
const url = Astro.url;
const pathname = Astro.url.pathname;
const searchParams = Astro.url.searchParams;
const id = searchParams.get('id');

// In dynamic routes [id].astro
const { id } = Astro.params;

// Redirect
if (!id) {
  return Astro.redirect('/404');
}
---
```

---

## Astro API Routes

### GET - Fetch Data
```typescript
// src/pages/api/items.ts
import type { APIRoute } from 'astro';
import { db } from '@lib/firebase';

export const GET: APIRoute = async () => {
  const items = await db.getDocs('items');

  return new Response(JSON.stringify(items), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
};
```

### GET - With Query Params
```typescript
import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ url }) => {
  const limit = parseInt(url.searchParams.get('limit') || '10');
  const offset = parseInt(url.searchParams.get('offset') || '0');

  const items = await fetchItems({ limit, offset });

  return new Response(JSON.stringify(items), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
};
```

### GET - Dynamic Route [id]
```typescript
// src/pages/api/items/[id].ts
import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ params }) => {
  const { id } = params;

  const item = await db.getDoc('items', id);

  if (!item) {
    return new Response(JSON.stringify({ error: 'Not found' }), {
      status: 404,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  return new Response(JSON.stringify(item), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
};
```

### POST - Create
```typescript
import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request }) => {
  const body = await request.json();

  // Validate
  if (!body.name) {
    return new Response(JSON.stringify({ error: 'Name required' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const id = await db.addDoc('items', {
    name: body.name,
    createdAt: new Date().toISOString(),
  });

  return new Response(JSON.stringify({ id }), {
    status: 201,
    headers: { 'Content-Type': 'application/json' },
  });
};
```

### PUT - Update
```typescript
import type { APIRoute } from 'astro';

export const PUT: APIRoute = async ({ params, request }) => {
  const { id } = params;
  const body = await request.json();

  const existing = await db.getDoc('items', id);
  if (!existing) {
    return new Response(JSON.stringify({ error: 'Not found' }), {
      status: 404,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  await db.updateDoc('items', id, {
    ...body,
    updatedAt: new Date().toISOString(),
  });

  return new Response(JSON.stringify({ success: true }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
};
```

### DELETE
```typescript
import type { APIRoute } from 'astro';

export const DELETE: APIRoute = async ({ params }) => {
  const { id } = params;

  await db.deleteDoc('items', id);

  return new Response(null, { status: 204 });
};
```

### Response Helpers
```typescript
// JSON response helper
const json = (data: unknown, status = 200) =>
  new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });

// Usage
return json({ items }, 200);
return json({ error: 'Not found' }, 404);
return json({ error: 'Server error' }, 500);
```

---

## Data Fetching

### Fetch in Component
```astro
---
// Runs on server at build/request time
const response = await fetch('https://api.example.com/data');
const data = await response.json();
---

<ul>
  {data.map(item => <li>{item.name}</li>)}
</ul>
```

### Fetch with Error Handling
```astro
---
let data = [];
let error = null;

try {
  const response = await fetch('https://api.example.com/data');
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  data = await response.json();
} catch (e) {
  error = e.message;
}
---

{error ? (
  <p class="error">{error}</p>
) : (
  <ul>
    {data.map(item => <li>{item.name}</li>)}
  </ul>
)}
```

### Client-Side Fetch
```astro
<button id="load-btn">Load Data</button>
<div id="results"></div>

<script>
  const btn = document.getElementById('load-btn');
  const results = document.getElementById('results');

  btn.addEventListener('click', async () => {
    try {
      const res = await fetch('/api/items');
      const data = await res.json();
      results.innerHTML = data.map(i => `<p>${i.name}</p>`).join('');
    } catch (err) {
      results.innerHTML = `<p class="error">${err.message}</p>`;
    }
  });
</script>
```

---

## Functional JS Patterns

### Pure Functions
```javascript
// Good: No side effects, same input = same output
const add = (a, b) => a + b;
const multiply = (a, b) => a * b;

// Avoid: Mutates external state
let total = 0;
const addToTotal = (n) => { total += n; }; // Bad
```

### Function Composition
```javascript
// Compose functions right-to-left
const compose = (...fns) => (x) => fns.reduceRight((acc, fn) => fn(acc), x);

// Pipe functions left-to-right
const pipe = (...fns) => (x) => fns.reduce((acc, fn) => fn(acc), x);

// Usage
const addOne = (x) => x + 1;
const double = (x) => x * 2;
const square = (x) => x * x;

const transform = pipe(addOne, double, square);
transform(2); // ((2 + 1) * 2)² = 36
```

### Currying
```javascript
// Convert multi-arg function to chain of single-arg functions
const curry = (fn) => {
  return function curried(...args) {
    if (args.length >= fn.length) {
      return fn.apply(this, args);
    }
    return (...nextArgs) => curried(...args, ...nextArgs);
  };
};

// Usage
const add = curry((a, b, c) => a + b + c);
add(1)(2)(3);     // 6
add(1, 2)(3);     // 6
add(1)(2, 3);     // 6

// Practical: Create specialized functions
const multiply = curry((a, b) => a * b);
const double = multiply(2);
const triple = multiply(3);

double(5); // 10
triple(5); // 15
```

### Partial Application
```javascript
// Fix some arguments, leave others open
const partial = (fn, ...presetArgs) => (...laterArgs) => fn(...presetArgs, ...laterArgs);

// Usage
const greet = (greeting, name) => `${greeting}, ${name}!`;
const sayHello = partial(greet, 'Hello');
sayHello('World'); // "Hello, World!"
```

### Higher-Order Functions
```javascript
// Function that takes/returns functions
const withLogging = (fn) => (...args) => {
  console.log(`Calling with: ${args}`);
  const result = fn(...args);
  console.log(`Result: ${result}`);
  return result;
};

const add = (a, b) => a + b;
const loggedAdd = withLogging(add);
loggedAdd(2, 3); // Logs and returns 5
```

### Memoization
```javascript
const memoize = (fn) => {
  const cache = new Map();
  return (...args) => {
    const key = JSON.stringify(args);
    if (cache.has(key)) return cache.get(key);
    const result = fn(...args);
    cache.set(key, result);
    return result;
  };
};

// Usage
const expensiveCalc = memoize((n) => {
  console.log('Computing...');
  return n * n;
});

expensiveCalc(5); // "Computing..." -> 25
expensiveCalc(5); // 25 (cached, no log)
```

---

## Array Operations

### Map - Transform Each Item
```javascript
const numbers = [1, 2, 3, 4, 5];

// Double each number
numbers.map(n => n * 2); // [2, 4, 6, 8, 10]

// Extract property
const users = [{ name: 'Alice' }, { name: 'Bob' }];
users.map(u => u.name); // ['Alice', 'Bob']

// With index
numbers.map((n, i) => `${i}: ${n}`); // ['0: 1', '1: 2', ...]
```

### Filter - Keep Matching Items
```javascript
const numbers = [1, 2, 3, 4, 5];

// Keep even numbers
numbers.filter(n => n % 2 === 0); // [2, 4]

// Filter objects
const users = [
  { name: 'Alice', active: true },
  { name: 'Bob', active: false },
];
users.filter(u => u.active); // [{ name: 'Alice', active: true }]

// Remove falsy values
[0, 1, '', 'hello', null, undefined].filter(Boolean); // [1, 'hello']
```

### Reduce - Accumulate to Single Value
```javascript
const numbers = [1, 2, 3, 4, 5];

// Sum
numbers.reduce((sum, n) => sum + n, 0); // 15

// Max
numbers.reduce((max, n) => n > max ? n : max, -Infinity); // 5

// Group by property
const items = [
  { type: 'fruit', name: 'apple' },
  { type: 'fruit', name: 'banana' },
  { type: 'veggie', name: 'carrot' },
];
items.reduce((groups, item) => {
  const key = item.type;
  groups[key] = groups[key] || [];
  groups[key].push(item);
  return groups;
}, {}); // { fruit: [...], veggie: [...] }

// Count occurrences
const words = ['apple', 'banana', 'apple', 'cherry', 'banana', 'apple'];
words.reduce((counts, word) => {
  counts[word] = (counts[word] || 0) + 1;
  return counts;
}, {}); // { apple: 3, banana: 2, cherry: 1 }
```

### Find - First Match
```javascript
const users = [
  { id: 1, name: 'Alice' },
  { id: 2, name: 'Bob' },
];

users.find(u => u.id === 2); // { id: 2, name: 'Bob' }
users.find(u => u.id === 99); // undefined

// Find index
users.findIndex(u => u.name === 'Bob'); // 1
```

### Some / Every - Test Conditions
```javascript
const numbers = [1, 2, 3, 4, 5];

// Some: at least one matches
numbers.some(n => n > 3); // true
numbers.some(n => n > 10); // false

// Every: all must match
numbers.every(n => n > 0); // true
numbers.every(n => n > 3); // false
```

### Flat / FlatMap
```javascript
// Flatten nested arrays
[[1, 2], [3, 4], [5]].flat(); // [1, 2, 3, 4, 5]
[1, [2, [3, [4]]]].flat(2); // [1, 2, 3, [4]]
[1, [2, [3, [4]]]].flat(Infinity); // [1, 2, 3, 4]

// Map then flatten
const sentences = ['Hello world', 'Foo bar'];
sentences.flatMap(s => s.split(' ')); // ['Hello', 'world', 'Foo', 'bar']
```

### Sort
```javascript
// Numbers (ascending)
[3, 1, 4, 1, 5].sort((a, b) => a - b); // [1, 1, 3, 4, 5]

// Numbers (descending)
[3, 1, 4, 1, 5].sort((a, b) => b - a); // [5, 4, 3, 1, 1]

// Strings
['banana', 'apple', 'cherry'].sort(); // ['apple', 'banana', 'cherry']

// Objects by property
const users = [{ name: 'Bob' }, { name: 'Alice' }];
users.sort((a, b) => a.name.localeCompare(b.name));
```

### Unique Values
```javascript
const arr = [1, 2, 2, 3, 3, 3];

// Using Set
[...new Set(arr)]; // [1, 2, 3]

// Unique objects by property
const users = [
  { id: 1, name: 'Alice' },
  { id: 2, name: 'Bob' },
  { id: 1, name: 'Alice' },
];
[...new Map(users.map(u => [u.id, u])).values()];
```

### Chain Operations
```javascript
const users = [
  { name: 'Alice', age: 25, active: true },
  { name: 'Bob', age: 30, active: false },
  { name: 'Charlie', age: 35, active: true },
];

// Get names of active users over 25, sorted
users
  .filter(u => u.active && u.age > 25)
  .map(u => u.name)
  .sort();
// ['Charlie']
```

---

## Object Operations

### Destructuring
```javascript
const user = { name: 'Alice', age: 25, city: 'NYC' };

// Basic
const { name, age } = user;

// Rename
const { name: userName } = user;

// Default values
const { country = 'USA' } = user;

// Nested
const data = { user: { profile: { name: 'Alice' } } };
const { user: { profile: { name } } } = data;

// Rest
const { name, ...rest } = user; // rest = { age: 25, city: 'NYC' }
```

### Spread
```javascript
const user = { name: 'Alice', age: 25 };

// Copy
const copy = { ...user };

// Merge
const withCity = { ...user, city: 'NYC' };

// Override
const updated = { ...user, age: 26 };

// Merge multiple
const merged = { ...obj1, ...obj2, ...obj3 };
```

### Object Methods
```javascript
const user = { name: 'Alice', age: 25 };

// Keys, values, entries
Object.keys(user);    // ['name', 'age']
Object.values(user);  // ['Alice', 25]
Object.entries(user); // [['name', 'Alice'], ['age', 25]]

// From entries
Object.fromEntries([['a', 1], ['b', 2]]); // { a: 1, b: 2 }

// Transform values
Object.fromEntries(
  Object.entries(user).map(([k, v]) => [k, String(v).toUpperCase()])
); // { name: 'ALICE', age: '25' }
```

### Pick / Omit
```javascript
// Pick specific keys
const pick = (obj, keys) =>
  Object.fromEntries(keys.filter(k => k in obj).map(k => [k, obj[k]]));

const user = { name: 'Alice', age: 25, city: 'NYC' };
pick(user, ['name', 'age']); // { name: 'Alice', age: 25 }

// Omit specific keys
const omit = (obj, keys) =>
  Object.fromEntries(Object.entries(obj).filter(([k]) => !keys.includes(k)));

omit(user, ['age']); // { name: 'Alice', city: 'NYC' }
```

### Deep Clone
```javascript
// Simple (works for JSON-safe objects)
const clone = (obj) => JSON.parse(JSON.stringify(obj));

// With structuredClone (modern)
const clone = structuredClone(obj);
```

---

## Async Patterns

### Basic Async/Await
```javascript
const fetchUser = async (id) => {
  const response = await fetch(`/api/users/${id}`);
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  return response.json();
};

// Usage
try {
  const user = await fetchUser(1);
  console.log(user);
} catch (error) {
  console.error('Failed:', error.message);
}
```

### Parallel Requests
```javascript
// Wait for all (fails if any fail)
const [users, posts] = await Promise.all([
  fetch('/api/users').then(r => r.json()),
  fetch('/api/posts').then(r => r.json()),
]);

// Wait for all (get results even if some fail)
const results = await Promise.allSettled([
  fetch('/api/users').then(r => r.json()),
  fetch('/api/posts').then(r => r.json()),
]);
results.forEach(r => {
  if (r.status === 'fulfilled') console.log(r.value);
  else console.error(r.reason);
});
```

### Sequential Requests
```javascript
// When each depends on previous
const user = await fetchUser(1);
const posts = await fetchPosts(user.id);
const comments = await fetchComments(posts[0].id);

// Process array sequentially
const ids = [1, 2, 3];
const results = [];
for (const id of ids) {
  results.push(await fetchItem(id));
}
```

### Retry Logic
```javascript
const retry = async (fn, retries = 3, delay = 1000) => {
  for (let i = 0; i < retries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === retries - 1) throw error;
      await new Promise(r => setTimeout(r, delay));
    }
  }
};

// Usage
const data = await retry(() => fetch('/api/data').then(r => r.json()));
```

### Debounce
```javascript
const debounce = (fn, delay) => {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
};

// Usage: Only call after 300ms of no activity
const search = debounce((query) => {
  fetch(`/api/search?q=${query}`);
}, 300);

input.addEventListener('input', (e) => search(e.target.value));
```

### Throttle
```javascript
const throttle = (fn, limit) => {
  let inThrottle;
  return (...args) => {
    if (!inThrottle) {
      fn(...args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
};

// Usage: Call at most once per 100ms
const handleScroll = throttle(() => {
  console.log('Scrolled');
}, 100);

window.addEventListener('scroll', handleScroll);
```

---

## Error Handling

### Try-Catch Pattern
```javascript
const safeJsonParse = (str) => {
  try {
    return { data: JSON.parse(str), error: null };
  } catch (error) {
    return { data: null, error: error.message };
  }
};

const { data, error } = safeJsonParse('{"valid": true}');
```

### Result Type Pattern
```javascript
// Return { ok, value } or { ok, error }
const fetchData = async (url) => {
  try {
    const res = await fetch(url);
    if (!res.ok) return { ok: false, error: `HTTP ${res.status}` };
    const data = await res.json();
    return { ok: true, value: data };
  } catch (error) {
    return { ok: false, error: error.message };
  }
};

// Usage
const result = await fetchData('/api/users');
if (result.ok) {
  console.log(result.value);
} else {
  console.error(result.error);
}
```

### Custom Errors
```javascript
class ValidationError extends Error {
  constructor(field, message) {
    super(message);
    this.name = 'ValidationError';
    this.field = field;
  }
}

class NotFoundError extends Error {
  constructor(resource) {
    super(`${resource} not found`);
    this.name = 'NotFoundError';
  }
}

// Usage
if (!user) throw new NotFoundError('User');
```

---

## TypeScript Patterns

### Common Types
```typescript
// Objects
interface User {
  id: string;
  name: string;
  email: string;
  age?: number;  // Optional
  readonly createdAt: string;  // Can't modify
}

// Functions
type Callback = (error: Error | null, data: unknown) => void;
type AsyncFn<T> = () => Promise<T>;

// Unions
type Status = 'pending' | 'active' | 'completed';
type Result = { success: true; data: User } | { success: false; error: string };

// Generics
type ApiResponse<T> = {
  data: T;
  status: number;
  message: string;
};
```

### Utility Types
```typescript
interface User {
  id: string;
  name: string;
  email: string;
  password: string;
}

// Partial - all optional
type UpdateUser = Partial<User>;

// Required - all required
type CompleteUser = Required<User>;

// Pick - select keys
type PublicUser = Pick<User, 'id' | 'name'>;

// Omit - exclude keys
type UserWithoutPassword = Omit<User, 'password'>;

// Record - object with key type
type UserMap = Record<string, User>;

// Readonly - immutable
type FrozenUser = Readonly<User>;
```

### Type Guards
```typescript
// Type predicate
const isUser = (value: unknown): value is User => {
  return (
    typeof value === 'object' &&
    value !== null &&
    'id' in value &&
    'name' in value
  );
};

// Usage
if (isUser(data)) {
  console.log(data.name); // TypeScript knows it's User
}

// Discriminated unions
type Result =
  | { type: 'success'; data: User }
  | { type: 'error'; message: string };

const handleResult = (result: Result) => {
  if (result.type === 'success') {
    console.log(result.data); // data is available
  } else {
    console.error(result.message); // message is available
  }
};
```

---

## DOM & Events

### Query Elements
```javascript
// Single element
const btn = document.getElementById('btn');
const first = document.querySelector('.item');

// Multiple elements
const items = document.querySelectorAll('.item');
items.forEach(item => console.log(item.textContent));

// Convert to array for array methods
const itemsArray = [...document.querySelectorAll('.item')];
```

### Create Elements
```javascript
const div = document.createElement('div');
div.className = 'card';
div.innerHTML = `
  <h3>${title}</h3>
  <p>${description}</p>
`;
container.appendChild(div);

// Insert HTML
container.insertAdjacentHTML('beforeend', `<p>New paragraph</p>`);
```

### Event Listeners
```javascript
// Basic
btn.addEventListener('click', (e) => {
  console.log('Clicked');
});

// With options
btn.addEventListener('click', handler, { once: true }); // Run once
btn.addEventListener('scroll', handler, { passive: true }); // Better perf

// Event delegation
container.addEventListener('click', (e) => {
  if (e.target.matches('.delete-btn')) {
    const id = e.target.dataset.id;
    deleteItem(id);
  }
});

// Remove listener
const handler = () => console.log('clicked');
btn.addEventListener('click', handler);
btn.removeEventListener('click', handler);
```

### Common Events
```javascript
// Form submit
form.addEventListener('submit', (e) => {
  e.preventDefault();
  const formData = new FormData(form);
  const data = Object.fromEntries(formData);
});

// Input change
input.addEventListener('input', (e) => {
  console.log(e.target.value);
});

// Keyboard
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') closeModal();
  if (e.key === 'Enter' && e.metaKey) submitForm();
});
```

---

## Forms

### Get Form Data
```javascript
const form = document.querySelector('form');

form.addEventListener('submit', (e) => {
  e.preventDefault();

  // As object
  const formData = new FormData(form);
  const data = Object.fromEntries(formData);

  // Individual values
  const name = formData.get('name');
  const tags = formData.getAll('tags'); // For multiple values
});
```

### Form Validation
```javascript
const validateForm = (data) => {
  const errors = {};

  if (!data.name?.trim()) {
    errors.name = 'Name is required';
  }

  if (!data.email?.includes('@')) {
    errors.email = 'Valid email required';
  }

  if (data.password?.length < 8) {
    errors.password = 'Password must be 8+ characters';
  }

  return {
    isValid: Object.keys(errors).length === 0,
    errors,
  };
};
```

### Submit Form
```javascript
const submitForm = async (form) => {
  const data = Object.fromEntries(new FormData(form));

  const response = await fetch('/api/submit', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.message);
  }

  return response.json();
};
```

---

## Local Storage

### Basic Operations
```javascript
// Set
localStorage.setItem('user', JSON.stringify({ name: 'Alice' }));

// Get
const user = JSON.parse(localStorage.getItem('user'));

// Remove
localStorage.removeItem('user');

// Clear all
localStorage.clear();
```

### Storage Helper
```javascript
const storage = {
  get: (key, defaultValue = null) => {
    try {
      const item = localStorage.getItem(key);
      return item ? JSON.parse(item) : defaultValue;
    } catch {
      return defaultValue;
    }
  },

  set: (key, value) => {
    localStorage.setItem(key, JSON.stringify(value));
  },

  remove: (key) => {
    localStorage.removeItem(key);
  },
};

// Usage
storage.set('user', { name: 'Alice' });
const user = storage.get('user', { name: 'Guest' });
```

---

## URL & Query Params

### Parse URL
```javascript
const url = new URL('https://example.com/path?foo=bar&baz=qux');

url.hostname;     // 'example.com'
url.pathname;     // '/path'
url.search;       // '?foo=bar&baz=qux'
url.searchParams.get('foo');  // 'bar'
url.searchParams.getAll('foo'); // ['bar']
```

### Build Query String
```javascript
const params = new URLSearchParams({
  query: 'search term',
  page: '1',
  limit: '10',
});

params.toString(); // 'query=search+term&page=1&limit=10'

// Append to URL
const url = `/api/search?${params}`;
```

### Parse Current URL
```javascript
// In browser
const params = new URLSearchParams(window.location.search);
const id = params.get('id');

// Update without reload
const url = new URL(window.location);
url.searchParams.set('page', '2');
window.history.pushState({}, '', url);
```

---

## Dates

### Formatting
```javascript
const date = new Date();

// ISO string
date.toISOString(); // '2024-01-15T10:30:00.000Z'

// Locale string
date.toLocaleDateString('en-US'); // '1/15/2024'
date.toLocaleTimeString('en-US'); // '10:30:00 AM'

// Custom format with Intl
new Intl.DateTimeFormat('en-US', {
  year: 'numeric',
  month: 'long',
  day: 'numeric',
}).format(date); // 'January 15, 2024'
```

### Date Math
```javascript
const date = new Date();

// Add days
const tomorrow = new Date(date);
tomorrow.setDate(date.getDate() + 1);

// Add months
const nextMonth = new Date(date);
nextMonth.setMonth(date.getMonth() + 1);

// Difference in days
const diffTime = Math.abs(date2 - date1);
const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
```

---

## Validation

### Common Validators
```javascript
const validators = {
  required: (v) => v != null && v !== '',
  email: (v) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v),
  minLength: (min) => (v) => v?.length >= min,
  maxLength: (max) => (v) => v?.length <= max,
  pattern: (regex) => (v) => regex.test(v),
  number: (v) => !isNaN(Number(v)),
  integer: (v) => Number.isInteger(Number(v)),
  url: (v) => {
    try { new URL(v); return true; }
    catch { return false; }
  },
};

// Usage
validators.email('test@example.com'); // true
validators.minLength(8)('password123'); // true
```

### Schema Validation
```javascript
const validateSchema = (data, schema) => {
  const errors = {};

  for (const [field, rules] of Object.entries(schema)) {
    for (const [rule, param] of Object.entries(rules)) {
      const value = data[field];

      if (rule === 'required' && param && !validators.required(value)) {
        errors[field] = `${field} is required`;
      }
      if (rule === 'email' && param && !validators.email(value)) {
        errors[field] = `${field} must be a valid email`;
      }
      if (rule === 'minLength' && !validators.minLength(param)(value)) {
        errors[field] = `${field} must be at least ${param} characters`;
      }
    }
  }

  return { isValid: Object.keys(errors).length === 0, errors };
};

// Usage
const schema = {
  name: { required: true, minLength: 2 },
  email: { required: true, email: true },
};
validateSchema({ name: 'Al', email: 'bad' }, schema);
```

---

## Firestore Patterns

### Get Documents
```javascript
// Get all
const items = await db.collection('items').get();
const data = items.docs.map(doc => ({ id: doc.id, ...doc.data() }));

// Get one
const doc = await db.collection('items').doc(id).get();
if (!doc.exists) throw new Error('Not found');
const item = { id: doc.id, ...doc.data() };

// Query
const active = await db.collection('items')
  .where('status', '==', 'active')
  .orderBy('createdAt', 'desc')
  .limit(10)
  .get();
```

### Write Documents
```javascript
// Add (auto ID)
const ref = await db.collection('items').add({
  name: 'New Item',
  createdAt: new Date().toISOString(),
});
const id = ref.id;

// Set (specific ID)
await db.collection('items').doc('my-id').set({
  name: 'Item',
  createdAt: new Date().toISOString(),
});

// Update (partial)
await db.collection('items').doc(id).update({
  name: 'Updated Name',
  updatedAt: new Date().toISOString(),
});

// Delete
await db.collection('items').doc(id).delete();
```

### Batch Writes
```javascript
const batch = db.batch();

// Multiple operations
batch.set(db.collection('items').doc('1'), { name: 'Item 1' });
batch.update(db.collection('items').doc('2'), { name: 'Updated' });
batch.delete(db.collection('items').doc('3'));

await batch.commit();
```

---

## Quick Copy Patterns

### API Handler Template
```typescript
export const GET: APIRoute = async ({ url, params }) => {
  try {
    // Your logic here
    return new Response(JSON.stringify(data), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};
```

### Fetch Wrapper
```javascript
const api = {
  get: (url) => fetch(url).then(r => r.json()),
  post: (url, data) => fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  }).then(r => r.json()),
  put: (url, data) => fetch(url, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  }).then(r => r.json()),
  delete: (url) => fetch(url, { method: 'DELETE' }),
};
```

### Event Handler Setup
```javascript
document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('form');
  const output = document.getElementById('output');

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(form));

    try {
      const result = await api.post('/api/submit', data);
      output.textContent = JSON.stringify(result, null, 2);
    } catch (error) {
      output.textContent = `Error: ${error.message}`;
    }
  });
});
```
