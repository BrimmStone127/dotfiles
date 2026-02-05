# Code Snippets Cheatsheet

Type the prefix and press `Tab` to expand (VS Code) or `<Tab>`/`<C-k>` (Neovim).

---

## JavaScript / TypeScript

### Console & Debug
| Prefix | Output |
|--------|--------|
| `cl` | `console.log();` |
| `clv` | `console.log('var:', var);` |
| `ce` | `console.error();` |

### Functions
| Prefix | Output |
|--------|--------|
| `af` | `const fn = () => { }` |
| `afi` | `const fn = () => expr` |
| `aaf` | `const fn = async () => { }` |
| `fn` | `function fn() { }` |
| `afn` | `async function fn() { }` |

### TypeScript Functions
| Prefix | Output |
|--------|--------|
| `taf` | `const fn = (x: T): R => { }` |
| `taaf` | `const fn = async (x: T): Promise<R> => { }` |
| `gfn` | `function fn<T>(x: T): R { }` |

### Error Handling
| Prefix | Output |
|--------|--------|
| `tc` | `try { } catch (e) { }` |
| `tcf` | `try { } catch (e) { } finally { }` |
| `atc` | `try { await } catch (e) { console.error }` |

### Conditionals
| Prefix | Output |
|--------|--------|
| `if` | `if (cond) { }` |
| `ife` | `if (cond) { } else { }` |
| `ter` | `cond ? a : b` |

### Loops
| Prefix | Output |
|--------|--------|
| `for` | `for (let i = 0; i < arr.length; i++)` |
| `forof` | `for (const x of arr)` |
| `forin` | `for (const k in obj)` |
| `foreach` | `arr.forEach((x) => { })` |

### Array Methods
| Prefix | Output |
|--------|--------|
| `map` | `arr.map((x) => )` |
| `filter` | `arr.filter((x) => )` |
| `reduce` | `arr.reduce((acc, x) => { }, init)` |
| `find` | `arr.find((x) => )` |

### Promises & Async
| Prefix | Output |
|--------|--------|
| `prom` | `new Promise((resolve, reject) => { })` |
| `pall` | `const [a, b] = await Promise.all([])` |

### Fetch / HTTP
| Prefix | Output |
|--------|--------|
| `fget` | Fetch GET with JSON parse |
| `fpost` | Fetch POST with body |

### Imports / Exports
| Prefix | Output |
|--------|--------|
| `imp` | `import x from 'mod'` |
| `imd` | `import { x } from 'mod'` |
| `exp` | `export { }` |
| `expd` | `export default` |
| `expc` | `export const x = ` |

### Destructuring
| Prefix | Output |
|--------|--------|
| `dob` | `const { a, b } = obj` |
| `dar` | `const [a, b] = arr` |

### Timers
| Prefix | Output |
|--------|--------|
| `timeout` | `setTimeout(() => { }, ms)` |
| `interval` | `setInterval(() => { }, ms)` |

### Classes
| Prefix | Output |
|--------|--------|
| `class` | `class X { constructor() { } }` |
| `classex` | `class X extends Y { }` |

### Testing
| Prefix | Output |
|--------|--------|
| `desc` | `describe('', () => { })` |
| `it` | `it('', () => { })` |
| `ita` | `it('', async () => { })` |
| `expect` | `expect(x).` |

---

## TypeScript Only

### Types & Interfaces
| Prefix | Output |
|--------|--------|
| `int` | `interface X { }` |
| `intex` | `interface X extends Y { }` |
| `type` | `type X = ` |
| `typeo` | `type X = { }` |
| `enum` | `enum X { }` |

### Type Utilities
| Prefix | Output |
|--------|--------|
| `partial` | `Partial<T>` |
| `required` | `Required<T>` |
| `pick` | `Pick<T, 'key'>` |
| `omit` | `Omit<T, 'key'>` |
| `record` | `Record<K, V>` |
| `ro` | `readonly` |

### Type Guards
| Prefix | Output |
|--------|--------|
| `guard` | `function isX(val): val is X { }` |

### Astro API Routes
| Prefix | Output |
|--------|--------|
| `apiroute` | Full API route with try/catch |
| `apiget` | GET route handler |
| `apipost` | POST route with body parsing |
| `resjson` | `new Response(JSON.stringify())` |

### Zod
| Prefix | Output |
|--------|--------|
| `zod` | Schema with type inference |

### React
| Prefix | Output |
|--------|--------|
| `rfc` | Functional component with props interface |
| `us` | `const [x, setX] = useState<T>()` |
| `ue` | `useEffect(() => { }, [])` |
| `um` | `useMemo(() => { }, [])` |
| `uc` | `useCallback(() => { }, [])` |

---

## Python

### Print & Debug
| Prefix | Output |
|--------|--------|
| `pr` | `print()` |
| `prf` | `print(f'')` |
| `prv` | `print(f'{var=}')` |

### Functions
| Prefix | Output |
|--------|--------|
| `def` | `def fn():` |
| `adef` | `async def fn():` |
| `deft` | `def fn(x: T) -> R:` |
| `adeft` | `async def fn(x: T) -> R:` |

### Classes
| Prefix | Output |
|--------|--------|
| `class` | `class X: def __init__` |
| `dataclass` | `@dataclass class X:` |

### Error Handling
| Prefix | Output |
|--------|--------|
| `try` | `try: except Exception as e:` |
| `tryf` | `try: except: finally:` |

### Control Flow
| Prefix | Output |
|--------|--------|
| `if` | `if cond:` |
| `ife` | `if cond: else:` |
| `ifee` | `if: elif: else:` |

### Loops
| Prefix | Output |
|--------|--------|
| `for` | `for x in items:` |
| `fore` | `for i, x in enumerate():` |
| `forr` | `for i in range():` |

### Comprehensions
| Prefix | Output |
|--------|--------|
| `lc` | `[x for x in items]` |
| `dc` | `{k: v for k in items}` |

### Context Managers
| Prefix | Output |
|--------|--------|
| `with` | `with x as y:` |
| `openf` | `with open('f', 'r') as f:` |

### Other
| Prefix | Output |
|--------|--------|
| `lam` | `lambda x: expr` |
| `main` | `def main(): if __name__ == '__main__':` |

### Flask Routes
| Prefix | Output |
|--------|--------|
| `froute` | `@bp.route() def fn():` |
| `fget` | GET route with try/catch |
| `fpost` | POST route with body parsing |

### Pytest
| Prefix | Output |
|--------|--------|
| `test` | `def test_x():` |
| `testa` | `@pytest.mark.asyncio async def test_x():` |
| `fixture` | `@pytest.fixture def x():` |

### Type Hints
| Prefix | Output |
|--------|--------|
| `tlist` | `list[T]` |
| `tdict` | `dict[K, V]` |
| `topt` | `T | None` |

---

## Quick Reference

**Most Used:**
- `cl` → console.log
- `af` → arrow function
- `atc` → async try-catch
- `map` / `filter` → array methods
- `fget` / `fpost` → fetch requests
- `int` / `type` → TypeScript types
- `apiget` / `apipost` → API routes
