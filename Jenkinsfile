pipeline {
	agent {
		node {
			label 'cis-win2016'
			customWorkspace "K:/jenkins_data/liblogicalaccess-swig/build-pipeline/${BRANCH_NAME}"
		}
	}

    options {
        gitLabConnection('Gitlab Pontos')
    }

    triggers {
        gitlab(
                triggerOnPush: true,
                triggerOnMergeRequest: true,
                branchFilterType: 'All',
        )
    }

    stages {
        stage('Build') {
            steps {
                powershell 'echo Build'
				//powershell 'islog-prebuild'
				// gitversion do not support vs2017 project for now https://github.com/GitTools/GitVersion/issues/1315
				//powershell 'sources/scripts/update-gitversion-vs2017proj.ps1 sources/LibLogicalAccessNet/LibLogicalAccessNet.csproj'
				//powershell 'sources/scripts/generate-swig.ps1'
				//powershell 'islog-build 1'
				//warnings canComputeNew: false, canResolveRelativePaths: false, categoriesPattern: '', consoleParsers: [[parserName: 'MSBuild']], defaultEncoding: '', excludePattern: '', healthy: '', includePattern: '', messagesPattern: '', unHealthy: ''
				//powershell 'islog-package'
            }
        }
        
		
		stage('Publish') {
            steps {
                powershell 'echo Publish'
				// No PDB publish since gitlink do not support pdb portable
                //powershell 'islog-publish'
            }
        }
    }

    post {
        failure {
            updateGitlabCommitStatus name: 'build', state: 'failed'
        }
        success {
            updateGitlabCommitStatus name: 'build', state: 'success'
        }
        unstable {
            updateGitlabCommitStatus name: 'build', state: 'success'
        }
    }
}