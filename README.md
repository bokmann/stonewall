# Stonewall

Stonewall is officially retired.  CanCan works well enough to do what this gem did, and is way more popular == way more support available.

## What did this gem do?

Stonewall was a permissions framework extracted from the StonePath Workflow Methodology.  In this methodology, permissions are controlled via a matrix of [role, variant, method].  Let me explain:

### Role
The first axis was the user's Role.  This might be things like 'group member', 'administrator', 'superuser', 'data entry clerk', and so on.

### Variant
Every permissioned object is allowed to vary its access based on some value.  In Stonepath, this was typically the field aasm_state, from the 'Acts As State MAchine' gem.  Thus, we could have different sets of permissions when a Case is in intake vs verification vs Under Review vs completed, etc.

### Method
Stonewall was a whitelist permission scheme, meaning that if it was guarded, and if you weren't explicitly allowed to use it, you were denied.  Stonewall would wrap methods with an access guard, and if you didn't have permission, it would throw an exception.

### Usage
On your class, you would define a stonepath configuration block that was composed of triples of role, variant, method that defined the possible permissions for that class in its various permutations.