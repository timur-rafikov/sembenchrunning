#!/bin/bash
# Тест VAL на logistics примере

cd /mnt/d/work/sembenchrunning

echo "=== Domain ==="
cat data/logistics/easy/1/logistics_easy_domain.pddl

echo ""
echo "=== Problem ==="
cat data/logistics/easy/1/logistics_easy_problem.pddl

echo ""
echo "=== Plan ==="
cat data/logistics/easy/1/logistics_easy_plan.pddl

echo ""
echo "=== VAL Output ==="
/mnt/d/work/VAL/build/bin/Validate \
  data/logistics/easy/1/logistics_easy_domain.pddl \
  data/logistics/easy/1/logistics_easy_problem.pddl \
  data/logistics/easy/1/logistics_easy_plan.pddl
echo "Exit code: $?"
