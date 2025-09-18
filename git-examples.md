# Git Merge, Rebase & Fast-Forward Examples

## Scenario Setup

```bash
# Create a new repository
git init git-demo
cd git-demo

# Create initial commit
echo "# Git Demo" > README.md
git add README.md
git commit -m "Initial commit"

# Create main branch
git branch -M main
```

## 1. Merge Examples

### Basic Merge
```bash
# Create feature branch
git checkout -b feature-branch

# Make changes
echo "Feature: Add new functionality" >> README.md
git add README.md
git commit -m "Add new feature"

# Switch back to main
git checkout main

# Merge feature branch
git merge feature-branch
```

### No Fast-Forward Merge
```bash
# Create another feature
git checkout -b feature-branch-2
echo "Another feature" >> README.md
git add README.md
git commit -m "Add another feature"

# Switch to main
git checkout main

# Merge without fast-forward
git merge --no-ff feature-branch-2 -m "Merge feature-branch-2"
```

## 2. Rebase Examples

### Basic Rebase
```bash
# Create feature branch
git checkout -b rebase-feature
echo "Rebase feature" >> README.md
git add README.md
git commit -m "Add rebase feature"

# Switch to main and make changes
git checkout main
echo "Main branch update" >> README.md
git add README.md
git commit -m "Update main branch"

# Rebase feature onto main
git checkout rebase-feature
git rebase main
```

### Interactive Rebase
```bash
# Create multiple commits
git checkout -b interactive-feature
echo "First change" >> README.md
git add README.md
git commit -m "First commit"

echo "Second change" >> README.md
git add README.md
git commit -m "Second commit"

echo "Third change" >> README.md
git add README.md
git commit -m "Third commit"

# Interactive rebase
git rebase -i HEAD~3
```

## 3. Fast-Forward Examples

### Fast-Forward Merge
```bash
# Create feature branch
git checkout -b ff-feature
echo "Fast forward feature" >> README.md
git add README.md
git commit -m "Add fast forward feature"

# Switch to main
git checkout main

# Fast-forward merge
git merge --ff-only ff-feature
```

### Check Fast-Forward Possibility
```bash
# Check if fast-forward is possible
git merge-base --is-ancestor ff-feature main && echo "Fast-forward possible" || echo "Fast-forward not possible"
```

## 4. Conflict Resolution

### Merge Conflicts
```bash
# Create conflicting changes
git checkout -b conflict-branch
echo "Conflicting line" >> README.md
git add README.md
git commit -m "Add conflicting line"

git checkout main
echo "Different conflicting line" >> README.md
git add README.md
git commit -m "Add different conflicting line"

# Attempt merge (will create conflict)
git merge conflict-branch

# Resolve conflict in README.md, then:
git add README.md
git commit -m "Resolve merge conflict"
```

### Rebase Conflicts
```bash
# Create rebase conflict
git checkout -b rebase-conflict
echo "Rebase conflict line" >> README.md
git add README.md
git commit -m "Add rebase conflict line"

git checkout main
echo "Main conflict line" >> README.md
git add README.md
git commit -m "Add main conflict line"

# Attempt rebase (will create conflict)
git checkout rebase-conflict
git rebase main

# Resolve conflict in README.md, then:
git add README.md
git rebase --continue
```

## 5. Useful Commands

### View History
```bash
# View commit history
git log --oneline --graph --all

# View merge commits only
git log --merges

# View rebase history
git reflog
```

### Branch Management
```bash
# List all branches
git branch -a

# Delete merged branches
git branch --merged | grep -v main | xargs git branch -d

# Delete remote tracking branches
git remote prune origin
```

### Undo Operations
```bash
# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Undo merge
git reset --hard HEAD~1

# Undo rebase
git reflog
git reset --hard HEAD@{n}  # where n is the reflog entry
```
