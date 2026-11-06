# AdRise Tubi

**this is a public clone. don't put too many things in here**

## How do I install these formulae?

`brew install adrise/tubi/<formula>`

Or `brew tap adrise/tubi` and then `brew install <formula>`.

## Terragrunt 0.x

`brew install adrise/tubi/terragrunt-legacy` installs and normally links the fixed compatibility release 0.99.5 for macOS on Apple Silicon or Intel. It declares a conflict with linked Homebrew core `terragrunt`.

If core Terragrunt is already linked, resolve the conflict explicitly before installing this formula. The formula does not automatically uninstall or unlink another provider.

Check the active command after installation:

```bash
command -v terragrunt
terragrunt --version
```

Installing core Terragrunt later can install an unlinked keg or produce a link conflict. Conflict declarations do not prevent explicit force, overwrite, or unlink operations. This formula does not guarantee a system-wide version lock.

Formula metadata regression checks: `/usr/bin/ruby tests/terragrunt.rb`. Native installation and link behavior require separate Homebrew tests.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
