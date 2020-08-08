
The code and queries etc here are unlikely to be updated as my process
evolves. Later repos will likely have progressively different approaches
and more elaborate tooling, as my habit is to try to improve at least
one part of the process each time around.

---------

Step 1: Scrape the results
==========================

```sh
bundle exec ruby scraper.rb https://en.wikipedia.org/wiki/2019_Newport_West_by-election | tee wikipedia.csv
```

Step 2: Generate possible missing IDs
=====================================

```sh
xsv search -v -s id 'Q' wikipedia.csv | xsv select name | tail +2 |
  sed -e 's/^/"/' -e 's/$/"@en/' | paste -s - |
  xargs -0 wd sparql find-candidates.js |
  jq -r '.[] | [.name, .item.value, .election.label, .constituency.label, .party.label] | @csv' |
  tee candidates.csv
```

These all look fine, so nothing to remove from this list.

No matches found for:

* Jonathan Clarke
* Richard Suchorzewski
* Philip Taylor
* Hugh Nicklin

But none of them seem to have Wikidata items yet, so it should be fine
to create those.

Step 3: Combine Those
=====================

```sh
xsv join -n --left 2 wikipedia.csv 1 candidates.csv | xsv select '7,1-5' | sed $'1i\\\nfoundid' > combo.csv
```

Step 4: Generate QuickStatements commands
=========================================

Tweak config variables in `generate-qs.csv`, and then:

```sh
bundle exec ruby generate-qs.csv | tee commands.qs
```

Then sent to QuickStatements as https://editgroups.toolforge.org/b/QSv2T/1596879691713/
