#!/bin/sh

if [ ! -n "$1" ]; then
  echo "Please enter the file path and file name"
  exit 1
else
 inputfilepath=$1
fi

since_vars="20230601" 
until_vars="20230830"

since_vars_sec=`date -d "${since_vars}" "+%s"`
until_vars_sec=`date -d "${until_vars}" "+%s"`


    #更新和获取远程所有分支以及更新本地分支集合缓存
echo "开始暂停"
git fetch origin && git fetch --all

sleep 10s
echo "结束暂停"
#all_remote_branches_p=("origin/v230908_2578" "origin/dev" "origin/test")
all_remote_branches_p=("origin/dev" "origin/test" "origin/idc-pre")
#################### 控制台输出开始 #########################################

consoleWLLP(){

         since_vars_sec_v=$1
         until_vars_sec_v=$2
         all_remote_branches_v=$3
         PROJECT=$(basename "$PWD")
        
         for remote_branch in ${all_remote_branches_v[*]}; do

            printf "\e[40;92m \n\nGitlab上的${PROJECT}项目${remote_branch}分支的成员数量、提交次数、代码行数信息统计开始......(●'◡'●)...(ง •_•)ง...\n\n  \e[0m"

            for((mx=${since_vars_sec_v}; mx<=${until_vars_sec_v}; mx+=86400));
             do
                
                since_vars_ymd=`date -d "@${mx}" +%Y-%m-%d`
                printf "\e[40;94m  %20s\n\n \e[0m" "以下是$since_vars_ymd日${PROJECT}项目${remote_branch}分支代码统计开始";

                printf "\e[40;95m \n1. ${PROJECT}项目${remote_branch}分支${since_vars_ymd}日项目成员数量： \e[0m"; git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --pretty='%aN' | \
                sort -u | wc -l | xargs -r -n 1 printf "\e[40;93m %s \n \e[0m"

                printf "\e[40;94m \n\n2. 按用户名统计${since_vars_ymd}日代码提交次数：\n\n \e[0m"

                printf "\e[40;96m %18s  %10s %10s\n \e[0m" "日期" "次数" "用户名"

                git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --pretty='%aN' | sort | uniq -c | sort -k1 -n -r  | \
                xargs -r -n 2 printf "\e[40;93m %18s  %5s %8s\n \e[0m" "${since_vars_ymd}";

                printf "\e[40;96m \n%10s \e[0m" "${since_vars_ymd}日代码提交次数合计：";
                printf "\e[40;93m %1s \e[0m" ""; git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --oneline | wc -l | \
                xargs -r -n 1 printf "\e[40;93m %s \n \e[0m"

                printf "\e[40;92m \n3. 按用户名统计${since_vars_ymd}日代码提交行数：\n\n \e[0m"
                printf "\e[40;96m %20s%20s%25s%25s%25s%25s\n \e[0m" "用户名" "分支" "日期" "总行数" "添加行数" "删除行数"
                git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --format='%aN' | sort -u -r | while read name; do printf "\e[40;93m %16s \e[0m" "$name"; \
                git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --author="$name" --pretty=tformat: --numstat | \
                awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%28s%20s%15s%20s%20s\n", "'"$remote_branch"'" , "'"$since_vars_ymd"'" , loc, add, subs}' | \
                xargs -r -n 5 printf "\e[40;93m %28s%20s%15s%20s%20s\n \e[0m"; done

                printf "\e[40;96m \n%25s    \e[0m" "${since_vars_ymd}日提交行数总计：";  git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --pretty=tformat: --numstat | \
                awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s %15s %14s %19s %19s \n", "'"$remote_branch"'" , "'"$since_vars_ymd"'" , loc, add, subs }' |  \
                xargs -r -n 5 printf "\e[40;93m %s %15s %14s %19s %19s \n \e[0m"

                printf "\n"

                # since_vars_ymd=`date -d "1 day ${since_vars_ymd}" +%s`
               printf "\e[40;91m %20s\n\n \e[0m" "以上是$since_vars_ymd日${PROJECT}项目${remote_branch}分支代码统计结果";
               printf "\n\n"
            done
           
        done  
         
}


consoleWLLP since_vars_sec until_vars_sec "${all_remote_branches_p[*]}"

#################### 控制台输出结束 #########################################


#################### 文件输出开始 #########################################


fileWLLP(){

         since_vars_sec_v=$1
         until_vars_sec_v=$2
         all_remote_branches_v=$3
         PROJECT=$(basename "$PWD")
        
         for remote_branch in ${all_remote_branches_v[*]}; do

            printf "\n\nGitlab上的${PROJECT}项目${remote_branch}分支的成员数量、提交次数、代码行数信息统计开始......(●'◡'●)...(ง •_•)ง... \n\n" >> ${inputfilepath};

            for((mx=${since_vars_sec_v}; mx<=${until_vars_sec_v}; mx+=86400));
             do
                
                since_vars_ymd=`date -d "@${mx}" +%Y-%m-%d`
                printf "%20s\n\n" "以下是${since_vars_ymd}日${PROJECT}项目${remote_branch}分支代码统计开始" >> ${inputfilepath};

                printf "\n1. ${PROJECT}项目${remote_branch}分支${since_vars_ymd}日项目成员数量：" >> ${inputfilepath} ; git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --pretty='%aN' | sort -u | wc -l >> ${inputfilepath};

                printf "\n\n2. 按用户名统计${since_vars_ymd}日代码提交次数：\n\n" >> ${inputfilepath};
                printf "%18s  %10s %10s\n" "日期" "次数" "用户名" >> ${inputfilepath};
                git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --pretty='%aN' | sort | uniq -c | sort -k1 -n -r  | \
                xargs -r -n 2 printf "%18s  %5s %8s\n" "${since_vars_ymd}"  >> ${inputfilepath};
                printf "\n%10s" "${since_vars_ymd}日代码提交次数合计：" >> ${inputfilepath};
                printf "%1s" ""; git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --oneline | wc -l  >> ${inputfilepath}

                printf "\n3. 按用户名统计${since_vars_ymd}日代码提交行数：\n\n" >> ${inputfilepath}
                printf "%20s%20s%25s%25s%25s%25s\n" "用户名" "分支" "日期" "总行数" "添加行数" "删除行数" >> ${inputfilepath};
                git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --format='%aN' | sort -u -r | while read name; do printf "%16s" "$name">> ${inputfilepath} ; \
                git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --author="$name" --pretty=tformat: --numstat | \
                awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%28s%20s%15s%20s%20s\n", "'"$remote_branch"'" , "'"$since_vars_ymd"'" , loc, add, subs}' \
                -  >> ${inputfilepath}; done

                printf "\n%25s   " "${since_vars_ymd}日提交行数总计：" >> ${inputfilepath};  git log ${remote_branch} --since="${since_vars_ymd} 00:00:00" --until="${since_vars_ymd} 23:59:59" --pretty=tformat: --numstat | \
                awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s %15s %14s %19s %19s \n", "'"$remote_branch"'" , "'"$since_vars_ymd"'" , loc, add, subs }' >> ${inputfilepath};

                printf "\n" >> ${inputfilepath};
                printf "%20s\n" "以上是$since_vars_ymd日${PROJECT}项目${remote_branch}分支代码统计结果" >> ${inputfilepath};
                printf "\n" >> ${inputfilepath};
            done
           
        done  

        printf "Gitlab上的${PROJECT}项目全部分支的成员数量、提交次数、代码行数信息统计已完成......(●'◡'●)...(ง •_•)ง... \n\n" >> ${inputfilepath} ;
}

trap 'onCtrlC' INT
function onCtrlC(){
        #捕获CTRL+C，当脚本被ctrl+c的形式终止时同时终止程序的后台进程
        kill -9 ${do_sth_pid} ${progress_pid}
        echo
        echo 'Ctrl+C exit 1'
        exit 1
}
do_sth(){
       fileWLLP since_vars_sec until_vars_sec "${all_remote_branches_p[*]}"
       printf "\e[40;92m Gitlab上的${PROJECT}项目全部分支的成员数量、提交次数、代码行数信息统计已完成......(●'◡'●)...(ง •_•)ง... \n \e[0m"
}
progress(){
        #进度条程序
        local main_pid=$1
        local length=30
        local ratio=1
        while [ "$(ps -p ${main_pid} | wc -l)" -ne "1" ] ; do
                mark='\e[40;92m > \e[0m'
                progress_bar=
                for i in $(seq 1 "${length}"); do
                        if [ "$i" -gt "${ratio}" ] ; then
                                mark='\e[40;91m - \e[0m'
                        fi
                        progress_bar="${progress_bar}${mark}"
                done
                printf "\e[40;92m Progress: \e[0m ${progress_bar}\r"
                ratio=$((ratio+1))
                #ratio=`expr ${ratio} + 1`
                if [ "${ratio}" -gt "${length}" ] ; then
                        ratio=1
                fi
                sleep 0.1
        done
}

do_sth &
do_sth_pid=$(jobs -p | tail -1)
progress "${do_sth_pid}" &
progress_pid=$(jobs -p | tail -1)
wait "${do_sth_pid}"
printf "\e[40;92m Progress: done                \n \e[0m"
