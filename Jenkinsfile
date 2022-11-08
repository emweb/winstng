#!/usr/bin/env groovy

properties([
  parameters([
    string(
      name: 'version',
      defaultValue: '',
      description: 'The Wt version to build',
    ),
    string(
      name: 'gitref',
      defaultValue: '',
      description: 'If defined, this overrides the version as the ref (e.g. branch name) of Wt to build.',
    ),
    string(
      name: 'gitrepo',
      defaultValue: 'https://github.com/emweb/wt.git',
      description: 'The git repository to clone Wt from if gitref is specified',
    ),
    choice(
      name: 'arch',
      choices: [
        'all',
        'amd64',
        'x86',
      ],
      description: 'Which architectures to build',
    ),
    choice(
      name: 'vcvars_ver',
      choices: [
        'all',
        '14.3',
        '14.2',
        '14.1',
      ],
      description: 'Which MSVC tool versions to build with',
    ),
  ]),
]);

def buildStartedManually() {
  return currentBuild.getBuildCauses()[0]['_class'] == 'hudson.model.Cause$UserIdCause';
}

if (!buildStartedManually()) {
  print "INFO: no automatic builds";
  currentBuild.result = 'ABORTED';
  return;
}

def user_profile_dir

node('win') {
  user_profile_dir = bat(returnStdout: true, script: 'echo %UserProfile%').trim().split(' ').last().trim()
}

pipeline {
  environment {
    EMAIL = credentials('wt-dev-mail')
  }
  options {
    buildDiscarder logRotator(artifactNumToKeepStr: '3', numToKeepStr: '20')
    disableConcurrentBuilds();
  }
  agent none
  stages {
    stage('ConfigureAndBuild') {
      matrix {
        agent {
          dockerfile {
            filename 'Dockerfile'
            label 'win'
            additionalBuildArgs '--isolation=hyperv --memory 2G'
            args "--isolation=process --mount type=bind,source=${user_profile_dir}\\winstng_downloads,target=C:\\winstng_downloads"
          }
        }
        when {
          anyOf {
            expression { params.arch == 'all' }
            expression { params.arch == env.ARCH }
          }
          anyOf {
            expression { params.vcvars_ver == 'all' }
            expression { params.vcvars_ver == env.VCVARS_VER }
          }
        }
        axes {
          axis {
            name 'ARCH'
            values 'amd64', 'x86'
          }
          axis {
            name 'VCVARS_VER'
            values '14.1', '14.2', '14.3'
          }
        }
        stages {
          stage('Configure') {
            steps {
              script {
                def gitargs = '';
                if (params.gitref) {
                  gitargs = "-DWTGIT=ON -DWTGITREPO=${params.gitrepo} -DWTGITTAG=${params.gitref}"
                }
                bat """
                      call C:\\BuildTools\\VC\\Auxiliary\\Build\\vcvarsall.bat ${env.ARCH} -vcvars_ver=${env.VCVARS_VER}

                      set Path=%ProgramFiles(x86)%\\NSIS;%Path%
                      set Path=C:\\Doxygen;%Path%
                      set Path=C:\\Qt\\6.4.0\\msvc2019_64\\bin;%Path%

                      set BaseDir=%CD%
                      set Prefix=%BaseDir%\\prefix-${env.ARCH}-${env.VCVARS_VER}
                      set BuildDir=%BaseDir%\\build-${env.ARCH}-${env.VCVARS_VER}
                      set SrcDir=%BaseDir%\\cmake

                      mkdir %BuildDir%
                      cd %BuildDir%
                      cmake.exe ^
                        -DWINST_BASEDIR_:PATH=%BaseDir% ^
                        -DWINST_BATDIR_:PATH=%BaseDir% ^
                        -DWINST_PREFIX_:PATH=%Prefix% ^
                        -DWINST_DOWNLOADS_DIR=C:\\winstng_downloads ^
                        ${gitargs} ^
                        -DWT_VERSION=${params.version} ^
                        -GNinja ^
                        -DSTANDALONE_ASIO=ON ^
                        %SrcDir%
                    """;
              }
            }
          }
          stage('Build') {
            steps {
              dir("build-${env.ARCH}-${env.VCVARS_VER}") {
                bat """
                      call C:\\BuildTools\\VC\\Auxiliary\\Build\\vcvarsall.bat ${env.ARCH} -vcvars_ver=${env.VCVARS_VER}

                      set Path=%ProgramFiles(x86)%\\NSIS;%Path%
                      set Path=C:\\Doxygen;%Path%
                      set Path=C:\\Qt\\6.4.0\\msvc2019_64\\bin;%Path%

                      ninja -v package
                    """;
              }
            }
          }
        }
        post {
          success {
            archiveArtifacts 'build-*/Wt-*-msvs*-Windows-*-SDK.exe,build-*/Wt-*-msvs*-Windows-*-SDK.zip';
          }
        }
      }
    }
  }
  post {
    failure {
      mail to: env.EMAIL,
           subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
           body: "Something is wrong with ${env.BUILD_URL}";
    }
    unstable {
      mail to: env.EMAIL,
           subject: "Unstable Pipeline: ${currentBuild.fullDisplayName}",
           body: "Something is wrong with ${env.BUILD_URL}";
    }
    success {
      mail to: env.EMAIL,
           subject: "Wt ${params.version}: Windows builds ready",
           body: "Windows builds are ready: ${env.BUILD_URL}";
    }
    cleanup {
      node('win') {
        cleanWs cleanWhenFailure: false, cleanWhenUnstable: false
      }
    }
  }
}
