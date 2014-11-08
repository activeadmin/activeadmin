require 'rails_helper'

describe ActiveAdmin::SoftDelete do
  before do
    allow(Rails.application.routes.url_helpers).to receive(:admin_softdeletes_path).and_return('This is dummy path.')
    allow(Softdelete).to receive(:paranoid?).and_return(true)
  end

  it 'Extended to ActiveAdmin::ResourceDSL' do
    expect(ActiveAdmin::ResourceDSL.method_defined?(:soft_delete)).to be_truthy
  end

  context 'When call soft_delete_actions' do
    let :admin_resource do
      namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
      namespace.batch_actions = true
      namespace.register(Softdelete) do
        soft_delete
      end
    end

    let :controller do
      admin_resource.controller.new.tap do |controller|
        allow(controller).to receive(:redirect_to)
        allow(controller).to receive(:resource).and_return(resource)
        allow(controller).to receive(:params).and_return({:controller => "SoftdeleteController"})
      end
    end

    let :resource do
      Softdelete.create!
    end

    describe 'MemberActions' do
      it 'Defined #soft_delete' do
        expect(admin_resource.controller.public_instance_methods).to include(:soft_delete)
      end

      it 'Defined #restore' do
        expect(admin_resource.controller.public_instance_methods).to include(:restore)
      end

      context 'When call action' do
        subject do
          controller.send(action)
        end

        context '#soft_delete' do
          let :action do
            'soft_delete'
          end

          it 'Receive #destroy and #redirect_to' do
            expect(resource).to receive(:destroy).once
            expect(controller).to receive(:redirect_to)
                .with('This is dummy path.', :notice => I18n.t("active_admin.actions.succesfully_soft_deleted")).once
            subject
          end
        end

        context '#restore' do
          let :action do
            'restore'
          end

          it 'Receive #recover and #redirect_to' do
            expect(resource).to receive(:recover).once
            expect(controller).to receive(:redirect_to)
                .with('This is dummy path.', :notice => I18n.t("active_admin.actions.succesfully_restored")).once
            subject
          end
        end

        context '#destroy' do
          let :action do
            'destroy'
          end

          it 'Receive #destroy! and #redirect_to' do
            expect(resource).to receive(:destroy!).once
            expect(controller).to receive(:redirect_to)
                .with('This is dummy path.', :notice => I18n.t("active_admin.actions.succesfully_destroyed")).once
            subject
          end
        end
      end
    end

    describe 'BatchActions' do
      it 'Defined #soft_delete' do
        expect(admin_resource.batch_actions.map{ |item| item.sym }).to include(:soft_delete)
      end

      it 'Defined #restore' do
        expect(admin_resource.batch_actions.map{ |item| item.sym }).to include(:restore)
      end

      it 'Defined #hard_delete' do
        expect(admin_resource.batch_actions.map{ |item| item.sym }).to include(:destroy)
      end

      context 'When call action' do
        let :controller do
          allow(Softdelete).to receive(:find).with([0,1]).and_return([resource, resource])
          admin_resource.controller.new.tap do |controller|
            allow(controller).to receive(:redirect_to)
            allow(controller).to receive(:resource).and_return(resource)
            allow(controller).to receive(:params).and_return({:controller => "SoftdeleteController", :collection_selection => [1,2]})
          end
        end

        let :resource do
          Softdelete.new
        end

        let :config do
          controller.instance_eval{active_admin_config}
        end

        let :batch_action do
          admin_resource.batch_actions.select{|act| act.sym == action}.first
        end

        subject do
          controller.instance_exec [0,1], &batch_action.block
        end

        context '#soft_delete' do
          let :action do
            :soft_delete
          end

          it 'Receive #destroy and redirect_to' do
            expect(resource).to receive(:destroy).twice
            expect(controller).to receive(:redirect_to).with('This is dummy path.',
              :notice => I18n.t("active_admin.batch_actions.succesfully_soft_deleted",
                               :count => 2,
                               :model => config.resource_label.downcase,
                               :plural_model => config.plural_resource_label(:count => 2).downcase)).once
            subject
          end
        end

        context '#restore' do
          let :action do
            :restore
          end

          it 'Receive #recover and redirect_to' do
            expect(resource).to receive(:recover).twice
            expect(controller).to receive(:redirect_to).with('This is dummy path.',
              :notice => I18n.t("active_admin.batch_actions.succesfully_restored",
                               :count => 2,
                               :model => config.resource_label.downcase,
                               :plural_model => config.plural_resource_label(:count => 2).downcase)).once
            subject
          end
        end


        context '#destroy' do
          let :action do
            :destroy
          end

          it 'Receive #destroy! and ' do
            expect(resource).to receive(:destroy!).twice
            expect(controller).to receive(:redirect_to).with('This is dummy path.',
              :notice => I18n.t("active_admin.batch_actions.succesfully_destroyed",
                               :count => 2,
                               :model => config.resource_label.downcase,
                               :plural_model => config.plural_resource_label(:count => 2).downcase)).once
            subject
          end
        end
      end
    end

    context 'When call with block' do
      let :admin_resource do
        namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
        namespace.batch_actions = true
        namespace.register(Softdelete) do
          soft_delete do |action, resource|
            resource.called_from_block(action, resource)
          end
        end
      end

      it 'Call block with :soft_delete' do
        expect(resource).to receive(:called_from_block).with(:soft_delete, resource)
        controller.soft_delete
      end

      it 'Call block with :restore' do
        expect(resource).to receive(:called_from_block).with(:restore, resource)
        controller.restore
      end

      it 'Call block with :hard_delete' do
        expect(resource).to receive(:called_from_block).with(:hard_delete, resource)
        controller.destroy
      end
    end
  end
end
