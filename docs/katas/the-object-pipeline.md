# Largest files

From a list of records describing files, produce the three largest under a given directory,
with their sizes rounded to megabytes and a total at the end. Do it as one pipeline, and at
no point turn anything into text.

Then write a function of your own that accepts its input from the pipeline rather than as
an argument.

## What it teaches

That the pipeline carries objects, not lines, which is the one thing PowerShell does
differently from every other shell. Nothing is parsed, because nothing was ever
serialised — `Where-Object` filters records, `Sort-Object` sorts on a property, and
`Measure-Object` reduces.

The second half is what makes a function of yours a first-class citizen of that pipeline:
`ValueFromPipeline` on a parameter, and a `process` block that runs once per item. Writing
one is how the difference between a shell script and a cmdlet becomes concrete.

The quirk to meet while you are here: a pipeline that matches exactly one thing hands back
the thing rather than a one-item collection, so indexing it reaches into the object.

## Where it sits

Step 3 on `powershell`. It assumes FizzBuzz, and leads to
[word wrap](word-wrap.md) and [string calculator](string-calculator.md).

## Not available in

`bash` pipes bytes and every stage reparses them, which is
[its own lesson](exit-status-and-the-subshell.md) and the best possible contrast. Nothing
else here has a pipeline in the language at all.

## Source

Written for this repo. Documented at
[about_Pipelines](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines).
