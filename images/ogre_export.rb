# Sketchup Backface Highlighting Version 1.0.0
# Written by Kojack
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place - Suite 330, Boston, MA 02111-1307, USA, or go to
# http://www.gnu.org/copyleft/lesser.txt.

module OgreExport
    @@tw = nil
    @@countTriangles = 0
    @@countVertices = 0
    @@countMaterials = 0
    @@countTextures = 0
    @@materialList = {}
    @@textures = []
    @@optionsDialog = nil
    
    module_function
    
    def extract_filename(s)
        i = s.rindex(/[:\/\\]/)
        if i
            s.slice(i+1..-1)
        else
            s
        end  
    end

    def remove_spaces(s)
        s.tr(' ', '_')
    end

    def append_paths(p,f)
        if p[-1,1] == "\\" or p[-1,1] == "/"
            p+f
        else
            p+"\\"+f
        end
    end

    def exportDialog()
        load "ogre_config.rb"
        if @@optionsDialog == nil
            @@optionsDialog = UI::WebDialog.new("Ogre Exporter Settings", true, "OgreSketchupExport", 739, 641, 150, 150, true);
            @@optionsDialog.set_file(Sketchup.find_support_file("ogre_export.htm","plugins"),nil)
        end
        @@optionsDialog.show_modal {
            @@optionsDialog.execute_script("setExportOption(\"FileMaterial\",#{OgreConfig::Paths.materials.inspect})") 
            @@optionsDialog.execute_script("setExportOption(\"FileMesh\",#{OgreConfig::Paths.meshes.inspect})") 
            @@optionsDialog.execute_script("setExportOption(\"FileTexture\",#{OgreConfig::Paths.textures.inspect})") 
            @@optionsDialog.execute_script("setExportOption(\"FileXMLConverter\",#{OgreConfig::Paths.converter.inspect})")
            @@optionsDialog.execute_script("setExportOption(\"ExportName\",#{OgreConfig.name.inspect})")
            @@optionsDialog.execute_script("setExportOption(\"TextScale\",\"#{OgreConfig.scale}\")")
            @@optionsDialog.execute_script("setExportOptionCheckbox(\"CheckboxMaterial\",#{OgreConfig.exportMaterials})") 
            @@optionsDialog.execute_script("setExportOptionCheckbox(\"CheckboxMesh\",#{OgreConfig.exportMeshes})") 
            @@optionsDialog.execute_script("setExportOptionCheckbox(\"CheckboxTexture\",#{OgreConfig.copyTextures})") 
            @@optionsDialog.execute_script("setExportOptionCheckbox(\"CheckboxXMLConverter\",#{OgreConfig.convertXML})")
            @@optionsDialog.execute_script("setExportOptionCheckbox(\"CheckboxDefaultMaterials\",#{OgreConfig.exportDefaultMaterials})")
            @@optionsDialog.execute_script("setExportOptionCheckbox(\"CheckboxBackFace\",#{OgreConfig.exportBackFaces})")
            @@optionsDialog.execute_script("setExportOptionCheckbox(\"CheckboxFrontFace\",#{OgreConfig.exportFrontFaces})")
            @@optionsDialog.execute_script("setExportOptionCheckbox(\"CheckboxRoot\",#{OgreConfig.exportRootFaces})")
            @@optionsDialog.execute_script("setExportOptionCheckbox(\"CheckboxMergeComponents\",#{OgreConfig.mergeComponents})")
            @@optionsDialog.execute_script("setExportOptionCheckbox(\"CheckboxSelectionOnly\",#{OgreConfig.selectionOnly})")
            @@optionsDialog.add_action_callback("on_export") {|d,p| grabDialogData; saveConfig; export; d.close} 
            @@optionsDialog.add_action_callback("on_cancel") {|d,p| d.close} 
        }
        @@optionsDialog = nil
    end

    def getDialogCheckbox(checkbox)
        @@optionsDialog.execute_script("getExportOptionCheckbox(\"#{checkbox}\")")
        if @@optionsDialog.get_element_value("HiddenInput") == "true"
            true
        else
            false
        end
    end

    def grabDialogData()
        if @@optionsDialog.visible?
            OgreConfig::Paths.materials = @@optionsDialog.get_element_value("FileMaterial")
            OgreConfig::Paths.meshes = @@optionsDialog.get_element_value("FileMesh")
            OgreConfig::Paths.textures = @@optionsDialog.get_element_value("FileTexture")
            OgreConfig::Paths.converter = @@optionsDialog.get_element_value("FileXMLConverter")
            OgreConfig.exportMaterials = getDialogCheckbox("CheckboxMaterial")
            OgreConfig.exportMeshes = getDialogCheckbox("CheckboxMesh")
            OgreConfig.copyTextures = getDialogCheckbox("CheckboxTexture")
            OgreConfig.exportBackFaces = getDialogCheckbox("CheckboxBackFace")
            OgreConfig.exportFrontFaces = getDialogCheckbox("CheckboxFrontFace")
            OgreConfig.exportRootFaces = getDialogCheckbox("CheckboxRoot")
            OgreConfig.mergeComponents = getDialogCheckbox("CheckboxMergeComponents")
            OgreConfig.convertXML = getDialogCheckbox("CheckboxXMLConverter")
            OgreConfig.selectionOnly = getDialogCheckbox("CheckboxSelectionOnly")
            OgreConfig.exportDefaultMaterials = getDialogCheckbox("CheckboxDefaultMaterials")
            OgreConfig.name = @@optionsDialog.get_element_value("ExportName")
            OgreConfig.scale = @@optionsDialog.get_element_value("TextScale").to_f
        end
    end

    def saveConfig()
        out = open(Sketchup.find_support_file("plugins")+"/ogre_config.rb", "w")
        out.print "module OgreConfig\n"
        out.print "  @@scale = #{OgreConfig.scale}\n"
        out.print "  @@copyTextures = #{OgreConfig.copyTextures}\n"
        out.print "  @@exportMeshes = #{OgreConfig.exportMeshes}\n"
        out.print "  @@exportMaterials = #{OgreConfig.exportMaterials}\n"
        out.print "  @@exportDefaultMaterials = #{OgreConfig.exportDefaultMaterials}\n"
        out.print "  @@exportStyle = #{OgreConfig.exportStyle}\n"
        out.print "  @@exportBackFaces = #{OgreConfig.exportBackFaces}\n"
        out.print "  @@exportFrontFaces = #{OgreConfig.exportFrontFaces}\n"
        out.print "  @@convertXML = #{OgreConfig.convertXML}\n"
        out.print "  @@exportRootFaces = #{OgreConfig.exportRootFaces}\n"
        out.print "  @@mergeComponents = #{OgreConfig.mergeComponents}\n"
        out.print "  @@name = #{OgreConfig.name.inspect}\n"
        out.print "  @@selectionOnly = #{OgreConfig.selectionOnly}\n"
        out.print "  def self.scale; @@scale; end\n"
        out.print "  def self.copyTextures; @@copyTextures; end\n"
        out.print "  def self.exportMeshes; @@exportMeshes; end\n"
        out.print "  def self.exportMaterials; @@exportMaterials; end\n"
        out.print "  def self.exportDefaultMaterials; @@exportDefaultMaterials; end\n"
        out.print "  def self.exportStyle; @@exportStyle; end\n"
        out.print "  def self.exportBackFaces; @@exportBackFaces; end\n"
        out.print "  def self.exportFrontFaces; @@exportFrontFaces; end\n"
        out.print "  def self.exportRootFaces; @@exportRootFaces; end\n"
        out.print "  def self.mergeComponents; @@mergeComponents; end\n"
        out.print "  def self.convertXML; @@convertXML; end\n"
        out.print "  def self.selectionOnly; @@selectionOnly; end\n"
        out.print "  def self.name; @@name; end\n"
        out.print "  def self.scale=(v); @@scale=v; end\n"
        out.print "  def self.copyTextures=(v); @@copyTextures=v; end\n"
        out.print "  def self.exportMeshes=(v); @@exportMeshes=v; end\n"
        out.print "  def self.exportMaterials=(v); @@exportMaterials=v; end\n"
        out.print "  def self.exportDefaultMaterials=(v); @@exportDefaultMaterials=v; end\n"
        out.print "  def self.exportStyle=(v); @@exportStyle=v; end\n"
        out.print "  def self.exportBackFaces=(v); @@exportBackFaces=v; end\n"
        out.print "  def self.exportFrontFaces=(v); @@exportFrontFaces=v; end\n"
        out.print "  def self.exportRootFaces=(v); @@exportRootFaces=v; end\n"
        out.print "  def self.mergeComponents=(v); @@mergeComponents=v; end\n"
        out.print "  def self.convertXML=(v); @@convertXML=v; end\n"
        out.print "  def self.selectionOnly=(v); @@selectionOnly=v; end\n"
        out.print "  def self.name=(v); @@name=v; end\n"
        out.print "  module Paths\n"
        out.print "    @@meshes = #{OgreConfig::Paths.meshes.inspect}\n"
        out.print "    @@materials = #{OgreConfig::Paths.materials.inspect}\n"
        out.print "    @@textures = #{OgreConfig::Paths.textures.inspect}\n"
        out.print "    @@converter = #{OgreConfig::Paths.converter.inspect}\n"
        out.print "    def self.meshes; @@meshes; end\n"
        out.print "    def self.materials; @@materials; end\n"
        out.print "    def self.textures; @@textures; end\n"
        out.print "    def self.converter; @@converter; end\n"
        out.print "    def self.meshes=(v); @@meshes=v; end\n"
        out.print "    def self.materials=(v); @@materials=v; end\n"
        out.print "    def self.textures=(v); @@textures=v; end\n"
        out.print "    def self.converter=(v); @@converter=v; end\n"
        out.print "  end\n"
        out.print "end\n"
        out.close
    end
    
    def collectFace(m, face, trans, handle, frontface, inherited_mat)
        index = nil
        (m.size).times {|i| if m[i][0]==handle then index = i end}
        if index
            m[index][1].push([face,trans,frontface, inherited_mat])
        else
            m.push([handle,[[face,trans,frontface, inherited_mat]]])
        end
    end
    
    def collectMaterials(matlist, ents, trans, inherited_mat, root)
        for e in ents
            case e
            when Sketchup::Face
                if (not root) or OgreConfig.exportRootFaces
                    if OgreConfig.exportFrontFaces
                        if e.material
                            mat = e.material
                            handle = @@tw.load(e,true)
                        else
                            if inherited_mat
                                mat = inherited_mat[0]
                                handle = @@tw.load(inherited_mat[1],true)
                            else
                                mat = nil
                                handle = 0
                            end
                        end
                        m = matlist[mat]
                        collectFace(m, e, trans, handle, true, if mat then nil else inherited_mat end)
                    end
                    if OgreConfig.exportBackFaces
                        if e.back_material
                            mat = e.back_material
                            handle = @@tw.load(e,false)
                        else
                            if inherited_mat
                                mat = inherited_mat[0]
                                handle = @@tw.load(inherited_mat[1],false)
                            else
                                mat = nil
                                handle = 0
                            end
                        end
                        m = matlist[mat]
                        collectFace(m, e, trans, handle, false, if mat then nil else inherited_mat end)
                    end
                end
            when Sketchup::Group
                collectMaterials(matlist, e.entities, trans*e.transformation, if e.material then [e.material,e,e.transformation] else inherited_mat end, root)
            when Sketchup::ComponentInstance
                collectMaterials(matlist, e.definition.entities, trans*e.transformation, if e.material then [e.material,e,e.transformation] else inherited_mat end, false)
            end
        end
    end

    def writeMaterials(matlist)
        file_material = open(append_paths(OgreConfig::Paths.materials,OgreConfig.name+".material"),"w")
        for m,m2 in matlist
            if m
                i = 0
                for handles in m2
                    if handles[1].size > 0
                        @@countMaterials = @@countMaterials + 1
                        mat_name = remove_spaces(m.display_name) + if i > 0 then "_distort_#{i}" else "" end
                        file_material.print "material #{mat_name}\n"
                        file_material.print "{\n"
                        file_material.print "   technique\n"
                        file_material.print "   {\n"
                        file_material.print "      pass\n"
                        file_material.print "      {\n"
                        if m.use_alpha?
                            file_material.print "         scene_blend alpha_blend\n"
                            file_material.print "         depth_check on\n"
                            file_material.print "         depth_write off\n"
                        end
                        if m.texture
                            #if extract_filename(m.texture.filename).index(/[ ]/)
                                #puts "Bad texture name: #{extract_filename(m.texture.filename)}"
                            #end
                            filename = extract_filename(remove_spaces(m.texture.filename))
                            ext_index = filename.rindex('.')
                            if ext_index
                                ext = filename.slice(ext_index+1..-1)
                                filename = filename.slice(0..ext_index-1)
                            else
                                ext = ""
                            end
                            filename = filename + if i > 0 then i.to_s else "" end + ".#{ext}"
                            file_material.print "         diffuse 1 1 1 #{m.alpha}\n"
                            file_material.print "         texture_unit\n"
                            file_material.print "         {\n"
                            file_material.print "            texture #{remove_spaces(filename)}\n"
                            file_material.print "         }\n"
                            if OgreConfig.copyTextures
                                @@countTextures = @@countTextures + 1
                                if handles[1][0][3]
                                    t = @@tw.write handles[1][0][3][1], append_paths(OgreConfig::Paths.textures, remove_spaces(filename))
                                else
                                    t = @@tw.write handles[1][0][0], handles[1][0][2],  append_paths(OgreConfig::Paths.textures, remove_spaces(filename))
                                end
                            end
                        else
                            file_material.print "         diffuse #{m.color.red/255.0} #{m.color.green/255.0} #{m.color.blue/255.0} #{m.alpha}\n"
                            file_material.print "         ambient #{m.color.red/255.0} #{m.color.green/255.0} #{m.color.blue/255.0} #{m.alpha}\n"
                        end
                        file_material.print "      }\n"
                        file_material.print "   }\n"
                        file_material.print "}\n\n"
                    end
                    i=i+1
                end
            end
        end
        if matlist[nil] and OgreConfig.exportDefaultMaterials
            @@countMaterials = @@countMaterials + 2
            if matlist[nil][0][1].size > 0
                file_material.print "material SketchupDefault\n"
                file_material.print "{\n"
                file_material.print "   technique\n"
                file_material.print "   {\n"
                file_material.print "      pass\n"
                file_material.print "      {\n"
                colour = Sketchup.active_model.rendering_options["FaceFrontColor"]
                file_material.print "         diffuse #{colour.red/255.0} #{colour.green/255.0} #{colour.blue/255.0}\n"
                file_material.print "         ambient #{colour.red/255.0} #{colour.green/255.0} #{colour.blue/255.0}\n"
                file_material.print "      }\n"
                file_material.print "   }\n"
                file_material.print "}\n\n"
                file_material.print "material SketchupDefault_Back\n"
                file_material.print "{\n"
                file_material.print "   technique\n"
                file_material.print "   {\n"
                file_material.print "      pass\n"
                file_material.print "      {\n"
                colour = Sketchup.active_model.rendering_options["FaceBackColor"]
                file_material.print "         diffuse #{colour.red/255.0} #{colour.green/255.0} #{colour.blue/255.0}\n"
                file_material.print "         ambient #{colour.red/255.0} #{colour.green/255.0} #{colour.blue/255.0}\n"
                file_material.print "      }\n"
                file_material.print "   }\n"
                file_material.print "}\n"
            end
        end
        file_material.close
    end

    def exportFaces(matlist)
        out = open(append_paths(OgreConfig::Paths.meshes, OgreConfig.name + ".mesh.xml"), "w")
        out.print "<mesh>\n"
        out.print "   <submeshes>\n"
        for m,m2 in matlist
            if m or OgreConfig.exportDefaultMaterials
                i = 0
                for handles in m2
                    if handles[1].size > 0
                        if m
                            mat_name = remove_spaces(m.display_name) + if i > 0 then "_distort_#{i}" else "" end
                            has_texture = m.texture != nil
                        else 
                            mat_name = "SketchupDefault"
                            has_texture = nil
                        end
                        meshes = []
                        tri_count = 0
                        vertex_count = 0
                        for face in handles[1]
                            mesh = face[0].mesh 7
                            # mesh = mesh2.transform face[1]
                            mirrored = face[1].xaxis.cross(face[1].yaxis).dot(face[1].zaxis) < 0
                            meshes.push([mesh,mirrored,face[0],face[1],face[2]])
                            tri_count = tri_count + mesh.count_polygons
                            vertex_count = vertex_count + mesh.count_points
                        end
                        @@countTriangles = @@countTriangles + tri_count
                        @@countVertices = @@countVertices + vertex_count
                        startindex = 0
                        out.print "      <submesh material = \"#{mat_name}\" usesharedvertices=\"false\" "
                        if vertex_count<65537 
                            out.print "use32bitindexes=\"false\">\n"
                        else
                            out.print "use32bitindexes=\"true\">\n"
                        end
                        out.print "         <faces count=\"#{tri_count}\">\n"
                        for mesh in meshes
                            for poly in mesh[0].polygons
                                v1 = (poly[0]>=0?poly[0]:-poly[0])+startindex
                                v2 = (poly[1]>=0?poly[1]:-poly[1])+startindex
                                v3 = (poly[2]>=0?poly[2]:-poly[2])+startindex
                                if mesh[1] == mesh[4]
                                    out.print "            <face v1=\"#{v2-1}\" v2=\"#{v1-1}\" v3=\"#{v3-1}\" />\n"
                                else
                                    out.print "            <face v1=\"#{v1-1}\" v2=\"#{v2-1}\" v3=\"#{v3-1}\" />\n"
                                end
                            end
                            startindex = startindex + mesh[0].count_points
                        end
                        out.print "         </faces>\n"
                        out.print "         <geometry vertexcount=\"#{vertex_count}\">\n"
                        out.print "            <vertexbuffer positions=\"true\" normals=\"true\" colours_diffuse=\"false\" "
                        if has_texture 
                            out.print "texture_coords=\"1\" texture_coord_dimensions_0=\"2\""
                        end
                        out.print " >\n"

                        for mesh in meshes
                            matrix = mesh[3]
                            #matrix = Geom::Transformation.new
                            for p in (1..mesh[0].count_points)
                                pos = (matrix*mesh[0].point_at(p)).to_a
                                norm = (matrix*mesh[0].normal_at(p)).to_a
                                out.print "               <vertex>\n"
                                out.print "                  <position x=\"#{pos[0]*OgreConfig.scale}\" y=\"#{pos[2]*OgreConfig.scale}\" z=\"#{pos[1]*-OgreConfig.scale}\" />\n"
                                if mesh[4]
                                    out.print "                  <normal x=\"#{norm[0]}\" y=\"#{norm[2]}\" z=\"#{-norm[1]}\" />\n"
                                else
                                    out.print "                  <normal x=\"#{-norm[0]}\" y=\"#{-norm[2]}\" z=\"#{norm[1]}\" />\n"
                                end
                                if has_texture
                                    if (mesh[2].material and mesh[4]) or (mesh[2].back_material and not mesh[4])
                                        texsize = Geom::Point3d.new(1, 1, 1)
                                    else
                                        texsize = Geom::Point3d.new(m.texture.width, m.texture.height, 1)
                                    end
                                    uvhelp = mesh[2].get_UVHelper true, true, @@tw
                                    #uv = [mesh[0].uv_at(p,1).x/texsize.x, mesh[0].uv_at(p,1).y/texsize.y, mesh[0].uv_at(p,1).z/texsize.z]
                                    #uv = [m.uv_at(p,1).x*1.0, m.uv_at(p,1).y*1.0, m.uv_at(p,1).z*1.0]
                                    if mesh[4]
                                        uv3d = uvhelp.get_front_UVQ mesh[0].point_at(p)
                                    else
                                        uv3d = uvhelp.get_back_UVQ mesh[0].point_at(p)
                                    end
                                    #uv3d = [mesh[0].uv_at(p,1).x, mesh[0].uv_at(p,1).y, mesh[0].uv_at(p,1).z]
                                    #out.print "                  <texcoord u=\"#{uv[0]}\" v=\"#{-uv[1]+1}\" />\n"
                                    out.print "                  <texcoord u=\"#{uv3d[0]/texsize.x}\" v=\"#{-uv3d[1]/texsize.y+1}\" />\n"
                                end
                                    out.print "               </vertex>\n"
                            end
                        end
                        out.print "            </vertexbuffer>\n"
                        out.print "         </geometry>\n"
                        out.print "      </submesh>\n"
                    end
                    i = i + 1
                end
            end
        end
        out.print "   </submeshes>\n"
        out.print "</mesh>\n"
        out.close
    end

    def export()
        @@countTriangles = 0
        @@countVertices = 0
        @@countMaterials = 0
        @@countTextures = 0
        @@materialList = {}
        @@textures = []
        @@tw = Sketchup.create_texture_writer
        
        tempface = Sketchup.active_model.entities.add_face(Geom::Point3d.new(23456,23456,23456), Geom::Point3d.new(23456,23457,23456), Geom::Point3d.new(23457,23456,23456))
        for m in Sketchup.active_model.materials
            tempface.material = m
            @@materialList[m] = [[@@tw.load(tempface,true),[]]]
        end
        @@materialList[nil] = [[0,[]]]
        Sketchup.active_model.entities.erase_entities tempface.edges
        puts "Collecting materials"
        if OgreConfig.selectionOnly
            selection = Sketchup.active_model.selection
            if selection.count == 0
                UI.messagebox "Nothing selected"
                @@tw = nil
                @@materialList = nil
                @@textures = nil
                return
            end
        else
            selection = Sketchup.active_model.entities
        end
        collectMaterials(@@materialList, selection, Geom::Transformation.new, nil, true)
        if OgreConfig.exportMaterials
            writeMaterials(@@materialList)
        end
        if OgreConfig.exportMeshes
            exportFaces(@@materialList)
        end
        if OgreConfig.convertXML
            system(OgreConfig::Paths.converter + " " + append_paths(OgreConfig::Paths.meshes,OgreConfig.name+".mesh.xml"))
        end
        @@tw = nil
        @@materialList = nil
        @@textures = nil
        puts "Triangles = #{@@countTriangles}\nVertices = #{@@countVertices}\nMaterials = #{@@countMaterials}\nTextures = #{@@countTextures}"
    end
end

menu = UI.menu "Tools";
menu.add_separator
menu.add_item( "Export To Ogre") {OgreExport.exportDialog}
