class StandardInput {
	[string]$user
	[string]$modus
	[string]$root
}

class Props {
	[string]$todayDateinFormatJJJJMMTT
	[string]$fileName
	[string]$pathWhereMappedFilesGetSaved
	[string]$pathToImportFile
	[string]$pathToLogFile
}

class PromptsDemo{
	[string]$demo1
    [string]$demo2
}

$standardInput = [StandardInput]::new()
$standardInput.user = "someUser"
$standardInput.modus = "someModus"
$standardInput.root = "someRoot"

$props = [Props]::new()
$props.todayDateinFormatJJJJMMTT = Get-Date -format yyyyMMdd
$props.pathWhereMappedFilesGetSaved = "somePathToDirectory"
$props.pathToImportFile = "somePathToDirectoryAndFile"
$props.pathToLogFile = "somePathToDirectory"
$props.fileName = "someFileName"


function importData($standardInput, $props, $prompts) {

	$protokoll = '{0}\{1}.log' -f (
		$props.pathToLogFile,
		$props.todayDateinFormatJJJJMMTT
		)


	$startTime = Get-Date
	write-output "--- Start Time: $startTime" | Out-File $protokoll -Append
	write-output " " | Out-File $protokoll -Append
	
    $inputFile = $props.pathToImportFile + $props.fileName

	Copy-item $inputFile $props.pathWhereMappedFilesGetSaved

	$inputCommand = "python " + $standardInput.root + " " + $standardInput.modus + " " + $standardInput.user + " " + $inputFile + " " + $prompts
	
	write-output "---- $inputCommand" | Out-File $protokoll -Append
	$execute = cmd /c $inputCommand >> $protokoll 2>&1
	write-output "---- $execute" | Out-File $protokoll -Append
	
	set-location $props.pathToImportFile
	remove-item $props.fileName

	$stopTime = Get-Date
	$runningTime = $stopTime - $startTime	 
	write-output " " | Out-File $protokoll -Append
	write-output "--- Stop Time: $stopTime, Running Time: $($runningTime.Hours)h:$($runningTime.Minutes)m:$($runningTime.Seconds)s:$($runningTime.Milliseconds)ms" | Out-File $protokoll -Append

}

if ($standardInput.modus -eq "SomeModus" -Or $standardInput.modus -eq "someModus"){

	$promptsDemo = [PromptsDemo]::new()
	$promptsDemo.demo1 = 'something'
	$promptsDemo.demo2 = 'something'

	$prompts = """'{0}'"" ""'{1}'""" -f (
		$promptsDemo.demo1,
		$promptsDemo.demo2
		)

}

if ($standardInput.modus -eq "secondModus"){

	$promptsDemo = [PromptsDemo]::new()
	$promptsDemo.demo1 = 'somethingElse'
	$promptsDemo.demo2 = 'somethingElse'

	$prompts = """'{0}'"" ""'{1}'""" -f (
		$promptsDemo.demo1,
		$promptsDemo.demo2
		)

}

importData $standardInput $props $prompts

if ($standardInput.modus -eq "secondModus"){
	exit
}

$props.filename = 'SomethingElse'

importData $standardInput $props $prompts

exit