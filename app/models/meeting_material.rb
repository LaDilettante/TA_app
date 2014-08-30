class MeetingMaterial < ActiveRecord::Base
  belongs_to :meeting
  has_attached_file :material

  validates_attachment :material, size: { in: 0..10.megabytes }

  before_post_process :set_content_type

  private

    def set_content_type
      self.material.instance_write(:content_type, MIME::Types.type_for(self.material_file_name).first.content_type.to_s)
    end
end