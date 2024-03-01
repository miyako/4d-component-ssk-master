#!/bin/bash


#*******************************************************************
#Script permettant la signature d'une application
# Parametres :
# 1 : Nom du certificat
# 2 : Chemin de l'application
#
#Retour 0 quand tous c'est bien passé
#ou Autre quand il y a une erreur
#*******************************************************************

#*******************************************************************
# function permettant de signer un fichier
# Parametres :
# 1 : Flag permettant de retourner l'erreur
# 2 : Nom du certificat
# 3 : Chemin du fichier
# 4 : Chemin du fichier 4D.entitlements (for .app only)
#
# Retour : Renvoi du flag d'erreur
#*******************************************************************
files=()

nameCertificat=$1
PathApp=$2
Entitlements=$3
LogPath=$4
boolError=0

filesToSign=('app' 'dylib' 'framework' 'so' 'bundle' 'plugin')
foldersToCheck=('Contents/Library/LaunchServices')
commands=""
IFS=$'
'

function PrepareCommand ()
{
    commands="find '$1'"

    for (( idx=0; idx<${#filesToSign[@]} ; idx++ )) ; do
        if [ $idx -ne 0 ]; then
            commands+=' -o'
        fi
        commands+=" -name '*.${filesToSign[idx]}'"
    done
}

function SignFile ()
{
    local CertifName="$1"
    local Entitlements="$2"
    local file="$3"
    local force="$4"

    if [ ! -L "$file" ]
        then
        if [ "$force" = true ]
            then
            codesign -f --sign "$CertifName" --verbose --timestamp --options runtime --entitlements "$Entitlements" "$file" 2>&1
            let FlagError=$?
        else
            v=$(eval "codesign --sign '$CertifName' --verbose --timestamp --options runtime --entitlements '$Entitlements' '$file' 2>&1")
            let FlagError=$?
            output=$v
            if [ "$FlagError" -eq "1" ]
			then
				local v=$(codesign -dvvv --verbose "$file" 2>&1)
				if [[ "$v" == *"Signature=adhoc"* ]]
				then
					if [[ "$1" == "-" ]]
					then
						let FlagError=0
					else
						v=$(eval "codesign -f --sign '$CertifName' --verbose --timestamp --options runtime --entitlements '$Entitlements' '$file' 2>&1")
						let FlagError=$?

                        output=$v
                    fi
                elif [[ "$v" == *"Authority="* ]] #Check if already signed
                then
                    let FlagError=0
                fi
            fi
            echo $output 2>&1
        fi
    fi
    return $FlagError
}

function Sign ()
{

    local FlagError="$1"
    local CertifName="$2"
    local PathSign="$3"
    local Entitlements="$4"
    local logSign="$5"
    local globalError=0

    if [[ ! -z $logSign ]]; then
        exec > $logSign
    fi

    PrepareCommand "$PathSign"
    xattr -rc "$PathSign"

    for line in $(eval $commands)
    do
        files+=("$line")
    done


    #Convert the name of "info.plist" to "Info.plist"
    for line in $(eval "find '$PathSign' -path '*/*.bundle/*' -name info.plist")
    do
    mv $line $(dirname "$line")/Info.plist
    done

    #Sign in revert order
    for (( idx=${#files[@]}-1 ; idx>=0 ; idx-- )) ; do

    for (( folderI=0; folderI<${#foldersToCheck[@]} ; folderI++ )) ; do
        local fullPath="${files[idx]}"/"${foldersToCheck[folderI]}"
        if test -d "$fullPath" ; then
            for line in "$fullPath"/*
            do
                if [ -f $line ]; then
                    SignFile "$CertifName" "$Entitlements" $line false
                    let FlagError=$?

                    #If the file is already signed, continue
                    if [ "$FlagError" -eq "1" ]; then
                        echo "Error $line"
                        let globalError=$FlagError
                        let FlagError=0
                    fi
                fi
            done
        fi



    done
		
        #Force the .app signature
        if [ "$idx" -eq "0" ]
            then
                SignFile "$CertifName" "$Entitlements" "${files[idx]}" true
        else
                SignFile "$CertifName" "$Entitlements" "${files[idx]}" false
        fi
        let FlagError=$?

        if [ "$FlagError" -eq "1" ]; then
            echo "Error ${files[idx]}"
            let globalError=$FlagError
            let FlagError=0
        fi
    done

    #The last one is the app folder. The app folder should not fail.
    return $globalError

}

function SignComponent ()
{
    local FlagError="$1"
    local CertifName="$2"
    local PathSign="$3"
    local Entitlements="$4"
    local logSign="$5"
    local globalError=0

    if [[ ! -z $logSign ]]; then
        exec > $logSign
    fi

    PrepareCommand "$PathSign"
    xattr -rc "$PathSign"

    for line in $(eval $commands)
    do
        files+=("$line")
    done

    #Sign in revert order
    for (( idx=${#files[@]}-1 ; idx>=0 ; idx-- )) ; do
        SignFile "$CertifName" "$Entitlements" "${files[idx]}" false
        
        let FlagError=$?

        if [ "$FlagError" -eq "1" ]; then
            echo "Error ${files[idx]}"
            let globalError=$FlagError
            let FlagError=0
        fi

    done

    #The last one is the app folder. The app folder should not fail.
    return $globalError

}

if [[ "${PathApp}" == *".4dbase"* ]]
	then
	SignComponent $boolError "${nameCertificat}" "${PathApp}" "${Entitlements}" "${LogPath}"
	else
	Sign $boolError "${nameCertificat}" "${PathApp}" "${Entitlements}" "${LogPath}"
fi

boolError=$?
exit $boolError

