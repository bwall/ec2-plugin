# This script runs when the slave starts up
$downloadLocation = $pwd

[environment]::SetEnvironmentVariable('JAVA_HOME', $installDir, 'machine')

$webclient = New-Object System.Net.WebClient
$userdata = $webclient.DownloadString("http://169.254.169.254/latest/user-data")
$jenkinsUrl = ""
$slaveName = ""
Foreach ($data in $userdata.split("&")) {
	if($data.Split("=")[0] -eq "JENKINS_URL") {
		$jenkinsUrl = $data.Split("=")[1]
	}
	if($data.Split("=")[0] -eq "SLAVE_NAME") {
		$slaveName = $data.Split("=")[1]
	}
}

# Download Start Up Powershell Script
$webclient = New-Object System.Net.WebClient
$url = "${jenkinsUrl}jnlpJars/slave.jar"
$file = "$downloadLocation\slave.jar"
$webclient.DownloadFile($url,$file)

[System.Diagnostics.Process]::Start("C:\Java\bin\java.exe", "-jar $file -jnlpUrl ${jenkinsUrl}computer/${slaveName}/slave-agent.jnlp")
