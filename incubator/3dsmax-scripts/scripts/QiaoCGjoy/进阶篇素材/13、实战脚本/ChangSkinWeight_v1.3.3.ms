-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2018-03-23----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
--2018-5-7 by Joe
--QQ: 738746223
-------------------------------------------------------

rollout Change_Weight "ChangeWeight_v1.3.3" width:162 height:205
(
	groupBox 'grp1' "CopySkin" pos:[4,7] width:154 height:99 align:#left

    --pickbutton 'source_bone' "from bone" pos:[35,26] width:93 height:21 toolTip:"选取需要被替换蒙皮的骨骼" align:#left
    button btn_cp "From Bone" pos:[37,26] width:93 height:21 toolTip:"复制选中骨骼权重" align:#left

	--pickbutton 'target_bone' "to bone" pos:[40,52] width:82 height:21 toolTip:"选取替换蒙皮的骨骼" align:#left
    button btn_ps "To Bone" pos:[37,52] width:93 height:21 toolTip:"权重剪贴到选中骨骼" align:#left

    checkbox ckb_sele_ver "" pos:[12,42] checked:false toolTip:"只作用于选中点模式"

	--button 'replaceskin' "Replace" pos:[84,78] width:54 height:21 toolTip:"选取骨骼后执行替换" align:#left

	--button 'Cle_btn' "Clean" pos:[25,78] width:43 height:21 toolTip:"清空选择的骨骼" align:#left

    progressBar Bar "ProgressBar" pos:[13,80] width:136 height:16 color:red--进度条
    -------------------------------------------------------------------------------------------------------------------------
    groupBox group_env "Envelope" pos:[4,110] width:154 height:71

    button btn_env_cp "Copy" pos:[13,129] width:64 height:21 toolTip:"复制当前选中封套"
    button btn_env_pa "Paste" pos:[84,129] width:64 height:21 toolTip:"黏贴封套到选中骨骼"
    button Reset_Env "ResEnv" pos:[55,153] toolTip:"选取模型重置封套"
    -------------------------------------------------------------------------------------------------------------------------
    hyperlink lbl_help "帮助" address:"https://www.cgjoy.com/thread-210984-1-1.html" align:#center offset:[0,10]
    --button btn_cp "From"
    --button btn_ps "To"

	local aBones
	local BoneID
    global in_R
    global out_R
    global objSkin
    global id_a
    global id_b
    global skin_bone
    global objmesh


	-- FUNCTIONS -------------------------------------------------------------------
    fn get_skin_mod_ver obj_skin=  --收集蒙皮下选中的 点
    (
        selectedVerts =#()
        for i = 1 to (skinOps.GetNumberVertices obj_skin) do --vertnum is number of vertices in skin object
        (
            theVert = skinOps.IsVertexSelected obj_skin i
            if theVert == 1 do (append selectedVerts i )
        )
        return selectedVerts
    )
    --------------------------------------------------
	fn returnObjectBones obj =
	(
		a = skinOps.getNumberBones obj
		for i in 1 to a collect (skinops.getBoneName obj i 1)
	)--收集蒙皮骨骼 名字
    --------------------------------------------------
    /*
	fn returnBoneIndex SkinBoneNum BoneName =
	(
		BoneID = 0

		for n = 1 to SkinBoneNum.count do
		(

			if 	SkinBoneNum[n] == BoneName do--then
            (
				BoneID = n
            )

		)

		return BoneID
	)*/
    ---返回骨骼ID
    --------------------------------------------------
    fn repskin fron_bone_ID to_bone_ID =
    (
        --try
       -- (
            --max modify mode  --打开蒙皮编辑窗口
            --objSkin = obj_Skin--$.skin  --获取蒙皮文件
            --objSkin = $.modifiers[#Skin]
            --if objSkin != undefined do--then
            undo "skin" on --撤销无效
            (
                SkinBoneNum = returnObjectBones objSkin   --获取蒙皮骨骼
                target_bone_ID = to_bone_ID --returnBoneIndex SkinBoneNum target_bone.text --获取目标骨骼ID
                --target_bone_ID = findItem SkinBoneNum target_bone.text   --获取目标骨骼ID
                --source_bone_ID = findItem SkinBoneNum source_bone.text
                source_bone_ID = fron_bone_ID  --returnBoneIndex SkinBoneNum source_bone.text --获取源骨骼ID

                if ckb_sele_ver.state then
                (
                    skin_ver = get_skin_mod_ver objSkin
                    if skin_ver.count !=0 then
                    (
                        numSkinVerts = skin_ver
                    )
                    else
                    (
                        numSkinVerts = #{1..(skinOps.getNumberVertices objSkin)}
                    )
                )
                else (
                    numSkinVerts = #{1..(skinOps.getNumberVertices objSkin)}  --获取参与蒙皮的点
                )
                -- numSkinVerts =skinOps.getNumberVertices objSkin --获取参与蒙皮的点


                if target_bone_ID != 0 and source_bone_ID != 0 then
                (
                    -- Process Skin --------------------------------------------------------

                    --for n = 1 to numSkinVerts do
                    for n in numSkinVerts do
                    (
                        -- Find number of bones effecting curent vertex

                        numBoneWeights = skinOps.getVertexWeightCount objSkin n   --获取骨骼ID为n参与的蒙皮点 --每个点有几根骨骼影响

                        -- Find all bone weights

                        aBoneID         = #()  --创建骨骼ID集合
                        aVertWeights    = #()  --创建权重中集合
                         -- skinOps.GetSelectedBone  skin  --当前选择骨骼序号
                        for b = 1 to numBoneWeights do
                        (
                            vertexWeight = skinOps.getVertexWeight objSkin n b   --获取第n个点的参与的第b个骨骼权重值
                            boneID       = skinOps.getVertexWeightBoneID objSkin n b  --获取第n个点参与的第b个骨骼的ID

                            append aBoneID boneID    --收集这个点参与的所有骨骼ID
                            append aVertWeights vertexWeight  ---收集这个点参与的每根骨骼ID的权重值
                        )

                        foundsource_boneIndex = 0
                        for b = 1 to aBoneID.count do   -- 解析查找被替换骨骼的的骨骼序列号数
                        (
                            if aBoneID[b] == source_bone_ID do--then
                            (
                                foundsource_boneIndex = b
                            )
                        )

                        foundtarget_boneIndex = 0
                        for b = 1 to aBoneID.count do   -- 解析查找替换骨骼的的骨骼序列号数
                        (
                            if aBoneID[b] == target_bone_ID do --then
                            (
                                foundtarget_boneIndex = b
                            )
                        )
                        if foundsource_boneIndex > 0 do --then
                        (
                            sourceWeight = aVertWeights[foundsource_boneIndex]  -- 收集

                            if foundtarget_boneIndex > 0 then
                            (
                                aVertWeights[foundtarget_boneIndex] += aVertWeights[foundsource_boneIndex]
                            )
                            else
                            (
                                append aVertWeights sourceWeight
                                append aBoneID target_bone_ID
                            )

                            deleteItem aVertWeights foundsource_boneIndex --删除权重数组中的第foundsource_boneIndex个权重
							
                            deleteItem aBoneID foundsource_boneIndex --删除骨骼ID数组中的第foundsource_boneIndex个骨骼ID
							
                            skinOps.replaceVertexWeights objSkin n aBoneID aVertWeights

                                -- End of this vertex
                            update $ --更新当前选择的
                        )
                        --Change_Weight.Bar.value = 100.*n/numSkinVerts
                        Change_Weight.Bar.value = 100.*n/(numSkinVerts.count)
                    )
                    Change_Weight.Bar.value = 0
                )
                else
                (
                    messageBox "ERROR: Source Bone not found in Skin!" title:"target2source"
                )
            )
            /*
            else
            (
                messageBox "模型没有蒙皮,是否选错了模型     "
            )
            */
       -- )catch (print "lllllllllllllllll")
    )

    --------------------------------------------------
	-- START OF SCRIPT -------------------------------------------------------------
    --skinOps.addbone <Skin> <Bone_node> <Update_integer>
    -----------------------------------------------------
    on btn_cp pressed do
    (
        objSkin = $.modifiers[#Skin]
        if objSkin != undefined do
        (
            id_a = skinOps.GetSelectedBone objSkin
			btn_cp.caption= skinOps.GetBoneName objSkin id_a 1
			
        )
		--source_bone.text = obj.name
		
    )
    on btn_ps pressed do
    (
        objSkin = $.modifiers[#Skin]
        if objSkin != undefined then
        (
            id_b = skinOps.GetSelectedBone objSkin
            if id_a != id_b do
            (
                repskin id_a id_b
			
            )
        )
        else(
            messageBox "模型没有蒙皮,是否选错了模型     "
        )
    )
    -----------------------------------------------------
	on btn_env_cp pressed do
	(

            objSkin =$.modifiers[#Skin]
            objmesh = $
            if objSkin != undefined do
            (
                skin_bone = returnObjectBones objSkin
                bone_id = skinOps.GetSelectedBone objSkin
                if bone_id != 0 then
                (
                    in_R =#() --内圈
                    out_R = #() -- 外圈
                    for i=1 to 2 do
                    (
                        in_R_a = skinOps.getInnerRadius objSkin bone_id i
                        in_R[i] = in_R_a

                        out_R_a = skinOps.getOuterRadius objSkin bone_id i
                        out_R[i] = out_R_a
                    )
                )
                else(
                    messageBox "选中骨骼错误  "
                )
            )
	)
    -----------------------------------------------------
    on btn_env_pa pressed do
    (
        if selection.count !=0 do
        (
            skinbones_name = for i in selection collect i.name
            select objmesh
            max modify mode
            --Change_Weight.Bar.color = blue
            for p= 1 to skinbones_name.count do
            (
                bone_id = findItem skin_bone skinbones_name[p]
                if bone_id != 0 do
                (

                    for o= 1 to 2 do
                    (
                        --try (
                            skinOps.setInnerRadius objSkin bone_id o in_R[o]   --内圈

                            skinOps.setOuterRadius objSkin bone_id o out_R[o]  --外圈
                        --)catch()
                    )
                    Change_Weight.Bar.value = 10.*p/(skinbones_name.count)
                )

            )
            Change_Weight.Bar.value = 0
        )
    )
    -----------------------------------------------------
    on Reset_Env pressed do
    (
        objSkin =$.modifiers[#Skin]
        --skin_BoneNum = returnObjectBones objSkin
        skin_BoneNum = skinOps.getNumberBones objSkin
        for i=1 to skin_BoneNum do
        (
            Bone_Name=skinOps.GetBoneName  objSkin i 1 ---获取ID骨骼名称
            --Bone_Name = ChangeName Bone_Name
            if Bone_Name != undefined do
            (
                try (
                    boneobj = execute ("$"+Bone_Name)
                    )
                catch
                (
                    boneobj = execute ("$"+"'"+Bone_Name+"'")
                )

            )
            case (classof boneobj ) of
            (
                BoneGeometry :
                (
                    --Bone_length=execute("$" + Bone_Name + ".length") ---获取骨骼长度
                    Bone_length=boneobj.length ---获取骨骼长度
                    --Bone_length * 0.2
                    --skinOps.setEndPoint objSkin i [0,0,0]
                    skinOps.setEndPoint objSkin i [0,0,0]   ---重置当前ID骨骼结束封套点
                    skinOps.setStartPoint objSkin i [Bone_length,0,0]  ---重置当前ID骨骼开始封套点
                )
                Biped_Object :
                (
                    /*
                    bound = nodeGetBoundingBox boneobj boneobj.transform
                    selSize = ( bound[2] - bound[1] )

                    --skinOps.setEndPoint objSkin i [0,0,0]
                    skinOps.setStartPoint objSkin i [(selSize.z*0.5),0,0]
                    */
                )
            )
            Change_Weight.Bar.value = (i / skin_BoneNum) * 100
        )
        Change_Weight.Bar.value = 0
    )
)
CreateDialog Change_Weight


