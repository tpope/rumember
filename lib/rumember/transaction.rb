class Rumember
  class Transaction < Abstract

    def id
      Integer(@attributes['transaction']['id'])
    end

    def undoable?
      @attributes['transaction']['undoable'] == '1'
    end

    def undone?
      !!@undone
    end

    def response
      @attributes
    end

    def params
      {'transaction_id' => id}
    end

    def undo
      if undone? || !undoable?
        false
      else
        dispatch('transactions.undo')
        @undone = true
      end
    end

  end
end
