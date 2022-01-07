import groovy.io.FileType
import groovy.transform.Field
import groovy.json.*

properties([
    parameters([
        [$class: 'DynamicReferenceParameter',
            name: 'app_version',
            description: 'App version',
            choiceType: 'ET_FORMATTED_HTML',
            script: [
                $class: 'GroovyScript',
                    fallbackScript: [
                        classpath: [],
                        sandbox:
                        true,
                        script: ''
                    ],
                script: [
                    classpath: [],
                    sandbox: true,
                    script: """
                    inputBox = "<input name='value' class='setting-input' type='text'>"
                    return inputBox
                    """
                ]
            ]
        ],
        [$class: 'DynamicReferenceParameter',
            name: 'web_content',
            description: 'Matan hagever',
            choiceType: 'ET_FORMATTED_HTML',
            script: [
                $class: 'GroovyScript',
                    fallbackScript: [
                        classpath: [],
                        sandbox:
                        true,
                        script: ''
                    ],
                script: [
                    classpath: [],
                    sandbox: true,
                    script: """
                    inputBox = "<input name='value' class='setting-input' type='text'>"
                    return inputBox
                    """
                ]
            ]
        ],
        [$class: 'DynamicReferenceParameter',
            name: 'replica',
            description: 'Recoukca',
            choiceType: 'ET_FORMATTED_HTML',
            script: [
                $class: 'GroovyScript',
                    fallbackScript: [
                        classpath: [],
                        sandbox:
                        true,
                        script: ''
                    ],
                script: [
                    classpath: [],
                    sandbox: true,
                    script: """
                    inputBox = "<input name='value' class='setting-input' type='text'>"
                    return inputBox
                    """
                ]
            ]
        ]


    ])
])

@NonCPS
def printParams() {
  env.getEnvironment().each { name, value -> println "Name: $name -> Value $value" }
}
printParams()

pipeline {
	environment {
		registryCredential = "docker"
	}
	
    agent any

    stages { 
		stage('Clean workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Clone Scripts') {
            steps {
                git credentialsId: 'git',
                url: 'https://github.com/matanbedani/pipeline.git',
                branch: "master"
            }
        }

        stage('docker build') {
            steps {
                script{
                    sh "sed 's/{WEB_CONTENT}}/${web_content[0..-2]}/' index.html"
                    sh "docker build --build-arg 'TAG=${app_version[0..-2]}' -t matanbedani/jenkins:$BUILD_NUMBER ."
                }
            }
        }
		stage('Deploy Image') {
            steps {
                script {
					docker.withRegistry('', registryCredential) {
                        sh "docker push matanbedani/jenkins:$BUILD_NUMBER"
                    }
                }
            }
        }
        stage('Remove unused images') {
            steps {
                script {
					sh "docker rmi matanbedani/jenkins:$BUILD_NUMBER"
                }
            }
        }
    }
        
        stage('Deploy kubernetes') {
            steps {
                script {
                       kubernetesDeploy(configs: "deploy.yaml", kubeconfigId: "kubernetes")  
                }    
            }  
         } 
}
