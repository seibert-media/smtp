def label = "buildpod.${env.JOB_NAME}".replaceAll(/[^A-Za-z-]+/, '-').take(62) + "p"

podTemplate(
	name: label,
	label: label,
	containers: [
		containerTemplate(
			name: 'build',
			image: 'eu.gcr.io/smedia-kubernetes/build-docker:1.3.2',
			ttyEnabled: true,
			command: 'cat',
			privileged: true,
			resourceRequestCpu: '500m',
			resourceRequestMemory: '500Mi',
			resourceLimitCpu: '2000m',
			resourceLimitMemory: '500Mi',
		),
	],
	volumes: [
		secretVolume(mountPath: '/home/jenkins/.docker', secretName: 'docker'),
		hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock'),
	],
	inheritFrom: '',
	namespace: 'jenkins',
	nodeSelector: 'cloud.google.com/gke-preemptible=true',
	serviceAccount: '',
	workspaceVolume: emptyDirWorkspaceVolume(false),
) {
	node(label) {
		properties([
			buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '14', numToKeepStr: '50')),
			pipelineTriggers([
				cron('H 2 * * *'),
				pollSCM('H/5 * * * *'),
			]),
		])
		try {
			container('build') {
				stage('Checkout') {
					timeout(time: 5, unit: 'MINUTES') {
						checkout([
							$class: 'GitSCM',
							branches: scm.branches,
							doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
							extensions: scm.extensions + [[$class: 'CloneOption', noTags: false, reference: '', shallow: true]],
							submoduleCfg: [],
							userRemoteConfigs: scm.userRemoteConfigs
						])
					}
				}
				stage('Bitbucket Notify') {
					timeout(time: 1, unit: 'MINUTES') {
						notifyBitbucket()
					}
				}
				stage('Trigger') {
					timeout(time: 5, unit: 'MINUTES') {
						env.TRIGGER = sh (script: "make trigger", returnStdout: true).trim()
						echo "trigger = ${env.TRIGGER}"
					}
				}
				stage('Build') {
					if (env.TRIGGER == 'build' || env.BRANCH_NAME != 'master') {
						timeout(time: 15, unit: 'MINUTES') {
							sh "make build"
						}
					}
				}
				stage('Upload') {
					if (env.TRIGGER == 'build' && env.BRANCH_NAME == 'master') {
						timeout(time: 15, unit: 'MINUTES') {
							sh "make upload"
						}
					}
				}
				stage('Clean') {
					if (env.TRIGGER == 'build' || env.BRANCH_NAME != 'master') {
						timeout(time: 5, unit: 'MINUTES') {
							sh "make clean"
						}
					}
				}
			}
			currentBuild.result = 'SUCCESS'
		} catch (any) {
			currentBuild.result = 'FAILURE'
			throw any //rethrow exception to prevent the build from proceeding
		} finally {
			notifyBitbucket()
			if ('FAILURE'.equals(currentBuild.result)) {
				emailext(
					body: '${DEFAULT_CONTENT}',
					mimeType: 'text/html',
					replyTo: '$DEFAULT_REPLYTO',
					subject: '${DEFAULT_SUBJECT}',
					to: emailextrecipients([
						[$class: 'CulpritsRecipientProvider'],
						[$class: 'RequesterRecipientProvider']
					])
				)
			}
		}
	}
}
