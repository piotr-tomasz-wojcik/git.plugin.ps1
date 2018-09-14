Set-Variable FATAL_ERROR_NOT_A_GIT_REPO -Option Constant -Scope script -Value 128 

function Get-GitCurrentBranch 
{
    ($ref = git symbolic-ref --quiet HEAD) 2>&1>$null
    if ($LastExitCode -ne 0)
    {
        if ($LastExitCode -eq $FATAL_ERROR_NOT_A_GIT_REPO) { return }
        
        ($ref = git rev-parse --short HEAD) 2>&1>$null
        if ($LastExitCode -ne 0) { return }
    }
    
    return $ref.Replace("refs/heads/", "")
}

function Update-GitBranchFromOrigin
{
    if ($args.Count -gt 1)
    {
        git pull origin $args
    }
    elseif ($args.Count -eq 1)
    {
        git pull origin $args[0]
    }
    else
    {
        git pull origin Get-GitCurrentBranch
    }
}

#Git
function Get-Git { & git $args }

New-Alias -Name g -Value Get-Git

#Add
function Add-GitFile    { & git add $args }
function Add-GitAllFiles { & git add --all $args }
function Add-GitPatch { & git add --patch $args }
function Add-GitUpdate { & git add --update $args }

New-Alias -Name ga -Value Add-GitFile
New-Alias -Name gaa -Value Add-GitAllFiles
New-Alias -Name gapa -Value Add-GitPatch
New-Alias -Name gau -Value Add-GitUpdate

#Branch
function Add-GitBranch { & git branch $args }
function Get-GitBranchAll { & git branch --all $args }
function Remove-GitMergedBranches { &"git branch -d" @(git branch --merged | Select-String -NotMatch -Pattern "^(*|\smaster\s$)") }
function Get-GitBranchNoMerged { & git branch --no-merged $args }
function Get-GitBranchRemote { & git branch --remote $args }

New-Alias -Name gb -Value Add-GitBranch
New-Alias -Name gba -Value Get-GitBranchAll
New-Alias -Name gbda -Value Remove-GitMergedBranches
New-Alias -Name gbnm -Value Get-GitBranchNoMerged
New-Alias -Name gbr -Value Get-GitBranchRemote

#Blame
function Get-GitBlame { & git blame -b -w $args }

#Bisect
function Get-GitBisect { & git bisect $args }
function Set-GitBisectBad { & git bisect bad $args }
function Set-GitBiSectGood { & git bisect good $args }
function Stop-GitBisect { & git bisect reset $args }
function Start-GitBisect { & git bisect start $args }

New-Alias -Name gbs -Value Get-GitBiscet
New-Alias -Name gbsb -Value Set-GitBisectBad
New-Alias -Name gbsg -Value Set-GitBiSectGood
New-Alias -Name gbsr -Value Stop-GitBisect
New-Alias -Name gbss -Value Start-GitBisect

#Commit
function Add-GitCommit { & git commit -v $args }
function Merge-GitCommitAmmend { & git commit -v --amend $args }
function Get-GitCommitAdd { & git commit -va $args }
function Get-GitCommitAddMessage { & git commit -vam $args }
function Get-GitCommitAddAmend { & git commit -v -a --amend $args }
function Get-GitCommitAddSignoffNoEditAmend { & git commit -vas --no-edit --amend $args }
function Get-GitCommitMessage { & git commit -m $args }
function Get-GitCommitSigned { & git commit -S $args }

Remove-Item -Force Alias:gc

New-Alias -Name gc -Value Add-GitCommit
New-Alias -Name gc! -Value Merge-GitCommitAmmend
New-Alias -Name gca -Value Get-GitCommitAdd
New-Alias -Name gcam -Value Get-GitCommitAddMessage
New-Alias -Name gca! -Value Get-GitCommitAddAmend
New-Alias -Name gcan! -Value Get-GitCommitAddSignoffNoEditAmend
New-Alias -Name gcmsg -Value Get-GitCommitMessage
#New-Alias -Name gcs -Value Get-GitCommitSigned

#Checkout
function Get-GitCheckout { & git checkout $args }
function Get-GitCheckoutBranch { & git checkout -b $args }
function Get-GitCheckoutMaster { & git checkout master $args }
function Get-GitCheckoutDevelop { & git checkout develop }

Remove-Item -Force Alias:gcm
Remove-Item -Force Alias:gcb

New-Alias -Name gco -Value Get-GitCheckout
New-Alias -Name gcb -Value Get-GitCheckoutBranch
New-Alias -Name gcm -Value Get-GitCheckoutMaster
New-Alias -Name gcd -Value Get-GitCheckoutDevelop

#Config
function Get-GitConfig { & git config --list $args }

New-Alias -Name gcf -Value Get-GitConfig

#Clone
function Get-GitClone { & git clone --recursive $args }

New-Alias -Name gcl -Value Get-GitClone

#Clean
function Get-GitClean { & git clean -df $args }

New-Alias -Name gclean -Value Get-GitClean

#Shortlog
function Measure-GitCommitsPerUser { & git shortlog -sn $args }

New-Alias -Name gcount -Value Get-GitShortlog

#Cherry-pick
function Get-GitCherryPick { & git cherry-pick $args }
function Get-GitCherryPickAbort { & get cherry-pick --abort $args }
function Get-GitCherryPickContinue { & get cherry-pick --continue $args }

New-Alias -Name gcp -Value Get-GitCherryPick
New-Alias -Name gcpa -Value Get-GitCherryPickAbort
New-Alias -Name gcpc -Value Get-GitCherryPickContinue

#Diff
function Get-GitDiff { & git diff $args }
function Get-GitDiffCached { & git diff --cached $args }
function Get-GitDiffTree { & git diff-tree --no-commit-id --name-only -r $args }
function Get-GitDiffWord { & git diff --word-diff $args }
function Get-GitDiffIgnoreWhitespaces { & git diff --ignore-all-space $args | vim - } #TODO: replace vim with view

New-Alias -Name gd -Value Get-GitDiff
New-Alias -Name gdca -Value Get-GitDiffCached
New-Alias -Name gdt -Value Get-GitDiffTree
New-Alias -Name gdw -Value Get-GitDiffWord
New-Alias -Name gdv -Value Get-GitDiffIgnoreWhitespaces

#Fetch
function Get-GitFetch { & git fetch $args }
function Get-GitFetchAllPrune { & git fetch --all --prune $args }
function Get-GitFetchOrigin { & git fetch origin $args }

New-Alias -Name gf -Value Get-GitFetch
New-Alias -Name gfa -Value Get-GitFetchAllPrune
New-Alias -Name gfo -Value Get-GitFetchOrigin

#Gui
function Get-GitGuiCitool { & git gui citool $args }
function Get-GitGuiCitoolAmend { & git gui citool --amend $args }

New-Alias -Name gg -Value Get-GitGuiCitool
New-Alias -Name gga -Value Get-GitGuiCitoolAmend

function Get-GitPush { & git push $args }
function Get-GitPushDryRun { & git push -dry-run $args }
function Get-GitPushAllTags { & git push origin --all Get-GitCurrentBranch $args }
function Get-GitPushUpstream { & git push upstream $args }
function Get-GitPushVerbose { & git push -v $args }
function Get-GitPushForce { & git push --force origin Get-GitCurrentBranch $args }
function Get-GitPushSetUpstream { git push --set-upstream origin Get-GitCurrentBranch $args }

Remove-Item -Force Alias:gp
Remove-Item -Force Alias:gpv

New-Alias -Name gp -Value Get-GitPush
New-Alias -Name gpd -Value Get-GitPushDryRun
New-Alias -Name gpoat -Value Get-GitPushAllTags
New-Alias -Name gpu -Value Get-GitPushUpstream
New-Alias -Name gpv -Value Get-GitPushVerbose
New-Alias -Name ggf -Value Get-GitPushForce
#New-Alias -Name ggpush ggp
New-Alias -Name gpsup -Value Get-GitPushSetUpstream

#Pull
function Get-GitPull { & git pull $args }
function Get-GitPullRebase { & git pull --rebase $args }
function Get-GitPullRebaseVerbose { & git pull -v --rebase $args }
function Get-GitPullUpstreamMaster { & git pull upstream master $args }

Remove-Item -Force Alias:gl

New-Alias -Name gl -Value Get-GitPull
New-Alias -Name gup -Value Get-GitPullRebase
New-Alias -Name gupv -Value Get-GitPullRebaseVerbose
New-Alias -Name glum -Value Get-GitPullUpstreamMaster

#Remote
function Get-GitRemote { & git remote $args }
function Get-GitRemoteVerbose { & git remote -v $args }
function Get-GitRemoteAdd { & git remote add $args }
function Get-GitRemoteRename { & git remote rename $args }
function Get-GitRemoteRemove { & git remote remove $args }
function Get-GitRemoteSetUrl { & git remote set-url $args }
function Get-GitRemoteUpdate { & git remote update $args }

New-Alias -Name gr -Value Get-GitRemote
New-Alias -Name grv -Value Get-GitRemoteVerbose
New-Alias -Name gra -Value Get-GitRemoteAdd
New-Alias -Name grmv -Value Get-GitRemoteRename
New-Alias -Name grrm -Value Get-GitRemoteRemove
New-Alias -Name grset -Value Get-GitRemoteSetUrl
New-Alias -Name grup -Value Get-GitRemoteUpdate

#Rebase
function Get-GitRebase { & git rebase $args }
function Get-GitRebaseAbort { & git rebase --abort $args }
function Get-GitRebaseContinue { & git rebase --continue $args }
function Get-GitRebaseInteractive { & git rebase -i $args }
function Get-GitRebaseMaster { & git rebase master }
function Get-GitRebaseSkip { & git rebase --skip $args }

New-Alias -Name grb -Value Get-GitRebase
New-Alias -Name grba -Value Get-GitRebaseAbort
New-Alias -Name grbc -Value Get-GitRebaseContinue
New-Alias -Name grbi -Value Get-GitRebaseInteractive
New-Alias -Name grbm -Value Get-GitRebaseMaster
New-Alias -Name grbs -Value Get-GitRebaseSkip

#Reset
function Get-GitResetPaths { & git reset -- $args }
function Get-GitResetHead { & git reset HEAD $args }
function Get-GitResetHeadHard { & git reset HEAD --hard $args }
function Get-GitPristine 
{
    git reset --hard
    if ($?) { git clean -dfx}
}

New-Alias -Name gru -Value Get-GitResetPaths
New-Alias -Name grh -Value Get-GitResetHead
New-Alias -Name grhh -Value Get-GitResetHeadHard
New-Alias -Name gpristine -Value Get-GitPristine

#Status
function Get-GitStatus { & git status $args }
function Get-GitStatusShort { & git status -s $args }
function Get-GitStatusShortBranch { & git status -sb $args }

New-Alias -Name gst -Value Get-GitStatus
New-Alias -Name gss -Value Get-GitStatusShort
New-Alias -Name gsb -Value Get-GitStatusShortBranch

