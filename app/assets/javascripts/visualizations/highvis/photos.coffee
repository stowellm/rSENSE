###
  * Copyright (c) 2011, iSENSE Project. All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
  *
  * Redistributions of source code must retain the above copyright notice, this
  * list of conditions and the following disclaimer. Redistributions in binary
  * form must reproduce the above copyright notice, this list of conditions and
  * the following disclaimer in the documentation and/or other materials
  * provided with the distribution. Neither the name of the University of
  * Massachusetts Lowell nor the names of its contributors may be used to
  * endorse or promote products derived from this software without specific
  * prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
  * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  * DAMAGE.
  *
###
$ ->
  if namespace.controller is 'visualizations' and
  namespace.action in ['displayVis', 'embedVis', 'show']

    class window.Photos extends BaseVis
      constructor: (@canvas) ->
      start: ->
        $('#' + @canvas).show()

        # Hide the controls
        @hideControls()
        super()

      # Gets called when the controls are clicked and at start
      update: ->
        # Clear the old canvas
        canvas = '#' + @canvas
        $(canvas).html("")

        # load the Handlebars templates
        picTemp = HandlebarsTemplates['visualizations/photo/pic']
        lbTemp = HandlebarsTemplates['visualizations/photo/lightbox']

        # add each photo to the canvas
        id = 0
        for dsKey,dset of data.metadata
          if dset.photos.length > 0
            for picKey,pic of dset.photos
              context = {
                p_id:   'pic-' + id
                tn_src: pic.tn_src
                src:    pic.src
                p_name: pic.name
                d_name: dset.name
                d_id:   dset.dataset_id
              }

              $(canvas).append picTemp(context)

              $('#pic-' + id).data('context', context)
              $('#pic-' + id).click ->
                ctx = $(this).data('context')
                $(canvas).append lbTemp(ctx)

                $('#target-img').modal
                  keyboard: true
                $('#target-img').on 'hidden.bs.modal', ->
                  $('#target-img').remove()

              id++

      end: ->
        @unhideControls()
        super()

      drawControls: ->
        super()

    if 'Photos' in data.relVis
      globals.photos = new Photos 'photos_canvas'
    else
      globals.photos = new DisabledVis 'photos_canvas'
