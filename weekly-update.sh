#!/bin/bash

# Weekly Development Summary Script
# Generates a clean summary of development progress without client references

echo "=== Weekly Development Update ==="
echo "Repository: $(basename $(git rev-parse --show-toplevel))"
echo "Week ending: $(date +%Y-%m-%d)"
echo "=================================="
echo ""

# Get PRs from the past 7 days
prs=$(gh pr list --state all --limit 100 --json number,title,author,mergedAt,createdAt,state,url,body --search "created:>=$(date -d '7 days ago' +%Y-%m-%d 2>/dev/null || date -v-7d +%Y-%m-%d)")

# Count PRs by state
merged_count=$(echo "$prs" | jq '[.[] | select(.state == "MERGED")] | length')
open_count=$(echo "$prs" | jq '[.[] | select(.state == "OPEN")] | length')
closed_count=$(echo "$prs" | jq '[.[] | select(.state == "CLOSED")] | length')

echo "📊 Week at a Glance:"
echo "  • ${merged_count} PRs merged successfully"
echo "  • ${open_count} PRs in progress"
echo "  • ${closed_count} PRs closed without merge"
echo ""

echo "🎯 Key Accomplishments This Week"
echo "================================="
echo ""

# Function to sanitize text by removing client references
sanitize_text() {
    local text="$1"
    # Remove common client-identifying patterns while preserving technical content
    echo "$text" | \
    sed -E 's/\b[A-Z][a-z]+Corp\b/[Company]/g' | \
    sed -E 's/\b[A-Z][a-z]+Inc\.?\b/[Company]/g' | \
    sed -E 's/\b[A-Z][a-z]+LLC\.?\b/[Company]/g' | \
    sed -E 's/\bclient[[:space:]]+[A-Za-z]+/client/gi' | \
    sed -E 's/\bcustomer[[:space:]]+[A-Za-z]+/customer/gi' | \
    sed -E 's/@[A-Za-z]+\.(com|org|net|io)/[domain]/g' | \
    sed -E 's/for [A-Z][a-z]+[[:space:]]+(Corp|Inc|LLC)/for [Company]/g'
}

# Process each merged PR with context
for pr_num in $(echo "$prs" | jq -r '.[] | select(.state == "MERGED") | .number'); do
    pr_data=$(gh pr view $pr_num --json title,author,body,mergedAt,comments,reviews 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        title=$(echo "$pr_data" | jq -r '.title')
        author=$(echo "$pr_data" | jq -r '.author.login')
        merged_date=$(echo "$pr_data" | jq -r '.mergedAt | split("T")[0]')
        body=$(echo "$pr_data" | jq -r '.body // "No description"')
        
        # Sanitize title and body
        clean_title=$(sanitize_text "$title")
        clean_body=$(sanitize_text "$body")
        
        echo "### PR #${pr_num}: ${clean_title}"
        echo "**Lead:** @${author} | **Merged:** ${merged_date}"
        echo ""
        
        # Extract the "What this does" or "Summary" section
        if echo "$clean_body" | grep -q "## What this does"; then
            echo "**What was accomplished:**"
            echo "$clean_body" | sed -n '/## What this does/,/^##/p' | sed '1d;$d' | head -10 | sed 's/^/  /'
        elif echo "$clean_body" | grep -q "## Summary"; then
            echo "**Context & Rationale:**"
            echo "$clean_body" | sed -n '/## Summary/,/^##/p' | sed '1d;$d' | head -10 | sed 's/^/  /'
        fi
        
        # Look for numbered lists (task breakdown)
        if echo "$clean_body" | grep -qE '^[0-9]+\.'; then
            echo ""
            echo "**Task Breakdown:**"
            echo "$clean_body" | grep -E '^[0-9]+\.' | head -5 | sed 's/^/  /'
        fi
        
        # Check for team coordination mentions (sanitized)
        if echo "$clean_body" | grep -qiE 'team|blocking|coordination'; then
            echo ""
            echo "**Team Coordination Notes:**"
            echo "$clean_body" | grep -iE 'team|blocking|coordination' | head -2 | sed 's/^/  > /'
        fi
        
        echo ""
        echo "---"
        echo ""
    fi
done

# Work in Progress section
if [ "$open_count" -gt 0 ]; then
    echo "🚧 Work in Progress"
    echo "==================="
    echo ""
    
    for pr_num in $(echo "$prs" | jq -r '.[] | select(.state == "OPEN") | .number'); do
        pr_data=$(gh pr view $pr_num --json title,author,body,createdAt 2>/dev/null)
        
        if [ $? -eq 0 ]; then
            title=$(echo "$pr_data" | jq -r '.title')
            author=$(echo "$pr_data" | jq -r '.author.login')
            created=$(echo "$pr_data" | jq -r '.createdAt | split("T")[0]')
            body=$(echo "$pr_data" | jq -r '.body // "No description"' | head -5)
            
            # Sanitize content
            clean_title=$(sanitize_text "$title")
            clean_body=$(sanitize_text "$body")
            
            echo "• **PR #${pr_num}**: ${clean_title}"
            echo "  Owner: @${author} | Started: ${created}"
            if [ "$clean_body" != "No description" ]; then
                echo "  Status: $(echo "$clean_body" | head -1 | sed 's/^#*\s*//')"
            fi
            echo ""
        fi
    done
fi

echo ""
echo "📈 Development Velocity"
echo "======================="
echo ""

# Calculate development metrics
total_prs=$((merged_count + open_count + closed_count))
if [ $total_prs -gt 0 ]; then
    merge_rate=$((merged_count * 100 / total_prs))
    echo "• Merge Rate: ${merge_rate}% (${merged_count}/${total_prs} PRs)"
fi

# Show contributor activity
echo "• Active Contributors:"
echo "$prs" | jq -r '.[] | .author.login' | sort | uniq -c | sort -rn | head -5 | while read count author; do
    echo "  - @${author}: ${count} PRs"
done

echo ""
echo "🎯 Issue Tracking & Milestone Progress"
echo "======================================"
echo ""

# Get issues closed this week
closed_issues=$(gh issue list --state closed --limit 100 --json number,title,closedAt,labels,milestone --search "closed:>=$(date -d '7 days ago' +%Y-%m-%d 2>/dev/null || date -v-7d +%Y-%m-%d)" 2>/dev/null)
closed_count=$(echo "$closed_issues" | jq 'length' 2>/dev/null || echo "0")

if [ "$closed_count" -gt 0 ]; then
    echo "**Issues Resolved This Week:** ${closed_count}"
    echo "$closed_issues" | jq -r '.[] | "  • #\(.number): \(.title)"' 2>/dev/null | while read line; do
        sanitize_text "$line"
    done
    echo ""
    
    # Check which PRs closed which issues
    echo "**PR → Issue Linkage:**"
    for pr_num in $(echo "$prs" | jq -r '.[] | select(.state == "MERGED") | .number'); do
        pr_body=$(gh pr view $pr_num --json body --jq '.body' 2>/dev/null)
        if echo "$pr_body" | grep -qE '(close|closes|closed|fix|fixes|fixed|resolve|resolves|resolved) #[0-9]+'; then
            linked_issues=$(echo "$pr_body" | grep -oE '#[0-9]+' | sort -u | tr '\n' ', ' | sed 's/,$//')
            echo "  • PR #${pr_num} → Issues: ${linked_issues}"
        fi
    done
    echo ""
else
    echo "• No issues tracked this week (consider creating issues for better tracking)"
    echo ""
fi

# Get active milestones
milestones=$(gh api repos/:owner/:repo/milestones --jq '.[] | select(.state == "open")' 2>/dev/null)

if [ -n "$milestones" ]; then
    echo "**Milestone Progress:**"
    echo "$milestones" | jq -r '"  • \(.title): \(.open_issues) open, \(.closed_issues) closed (\((.closed_issues * 100 / (.open_issues + .closed_issues)) | floor)% complete)"' 2>/dev/null
    echo ""
    
    # Show upcoming milestone due dates
    echo "**Upcoming Deadlines:**"
    echo "$milestones" | jq -r 'select(.due_on != null) | "  • \(.title): Due \(.due_on | split("T")[0])"' 2>/dev/null
else
    echo "• No active milestones (consider setting milestones for sprint planning)"
fi

echo ""
echo "🔍 Technical Highlights"
echo "======================="
echo ""

# Extract technical details from PR bodies (sanitized)
echo "**Architecture & Infrastructure Changes:**"
echo "$prs" | jq -r '.[] | select(.state == "MERGED") | .body // ""' | while read line; do
    sanitize_text "$line"
done | grep -iE 'architect|infrastructure|port|websocket|sqs|redis|django|fastapi|backend|frontend|database|api|service' | head -5 | sed 's/^/• /' | sort -u

echo ""
echo "**UI/UX Improvements:**"
echo "$prs" | jq -r '.[] | select(.state == "MERGED") | .body // ""' | while read line; do
    sanitize_text "$line"
done | grep -iE 'ui|ux|interface|design|style|align|render|markdown|sidebar|login|chat|component|layout' | head -5 | sed 's/^/• /' | sort -u

echo ""
echo "**Documentation & Process:**"
echo "$prs" | jq -r '.[] | select(.state == "MERGED") | .body // ""' | while read line; do
    sanitize_text "$line"
done | grep -iE 'document|readme|instruction|guide|setup|deploy' | head -5 | sed 's/^/• /' | sort -u

echo ""
echo "📝 Tech Debt & Future Work"
echo "=========================="
echo ""

# Analyze PR bodies and comments for tech debt and future work
tech_debt_found=false

for pr_num in $(echo "$prs" | jq -r '.[] | select(.state == "MERGED" or .state == "OPEN") | .number'); do
    pr_details=$(gh pr view $pr_num --json title,body,comments,reviews 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        title=$(echo "$pr_details" | jq -r '.title')
        body=$(echo "$pr_details" | jq -r '.body // ""')
        comments=$(echo "$pr_details" | jq -r '.comments[].body // ""' 2>/dev/null)
        reviews=$(echo "$pr_details" | jq -r '.reviews[].body // ""' 2>/dev/null)
        
        # Combine and sanitize all text for analysis
        all_text="${body} ${comments} ${reviews}"
        clean_text=$(sanitize_text "$all_text")
        clean_title=$(sanitize_text "$title")
        
        # Check for tech debt indicators
        if echo "$clean_text" | grep -qiE 'TODO|FIXME|HACK|tech debt|technical debt|temporary|workaround|quick fix|needs refactor|should be|could be better|not ideal'; then
            
            if [ "$tech_debt_found" = false ]; then
                echo "**Identified Tech Debt & TODOs:**"
                tech_debt_found=true
            fi
            
            echo ""
            echo "From PR #${pr_num}: ${clean_title}"
            
            # Extract specific mentions
            echo "$clean_text" | grep -iE 'TODO|FIXME|HACK|tech debt|technical debt|temporary|workaround|quick fix|needs refactor' | head -3 | sed 's/^/  → /' | sed 's/[[:space:]]\+/ /g'
        fi
        
        # Check for future work assignments or handoffs
        if echo "$clean_text" | grep -qiE 'can now|ready to|ready for|unblock|no longer blocking|handoff|take over|assign|team can'; then
            echo ""
            echo "**Handoff Ready - PR #${pr_num}:**"
            echo "$clean_text" | grep -iE 'can now|ready to|ready for|unblock|no longer blocking|handoff|take over|team can' | head -2 | sed 's/^/  ✓ /' | sed 's/[[:space:]]\+/ /g'
        fi
    fi
done

if [ "$tech_debt_found" = false ]; then
    echo "• No significant tech debt identified this week"
fi

echo ""
echo "🚀 Next Sprint Recommendations"
echo "=============================="
echo ""

# Analyze patterns for recommendations
echo "Based on this week's work:"

# Check for test-related issues
if echo "$prs" | jq -r '.[].body // ""' | grep -qiE 'test|lint|fix test|failing test'; then
    echo "• ⚠️  Test suite needs attention (failing tests mentioned)"
fi

# Check for documentation needs
if echo "$prs" | jq -r '.[].body // ""' | grep -qiE 'document|needs doc|missing doc|README'; then
    echo "• 📚 Documentation updates in progress"
fi

# Check for rough edges mentioned
if echo "$prs" | jq -r '.[].body // ""' | grep -qiE 'rough|not verified|needs cleanup|frontend.*issues'; then
    echo "• 🔧 Frontend polish needed (rough edges noted)"
fi

# Check for successful handoffs
if echo "$prs" | jq -r '.[].body // ""' | grep -qiE 'no longer blocking|foundation.*ready|team.*iterate'; then
    echo "• ✅ Core infrastructure ready for team development"
fi

echo ""
echo "=== End of Weekly Summary ==="